//
//  DBManager.m
//  ShopPRPS
//
//  Created by Daniel Muraveyko on 30/04/2017.
//  Copyright © 2017 Daniel Muraveyko. All rights reserved.
//

#import "DBManager.h"

static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
    }
    return sharedInstance;
}

+(int) findByLoginAndPassword:(NSString*)login password:(NSString*)password {
    
    if (sqlite3_open("/Users/danielmuraveyko/Google Drive/Xcode/ShopPRPS/shopDB.db", &database) == SQLITE_OK){
    
        NSString *querySQL = [NSString stringWithFormat:
            @"select position from Employees where (login=\"%@\" and password=\"%@\") ",login, password];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database,
                            query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {

            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *position = [[NSString alloc] initWithUTF8String:
                                (const char *) sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                return [position intValue];
            }
        }
        else{
            sqlite3_reset(statement);
            return -1;
        }
    }
    return -1;
}

+(int)newCardNum{
    int card = 0;
    
    for(int i = 0; i < 4; i++){
        card += arc4random_uniform(9);
        card *= 10;
    }
    return card;
}

+(int) addProduct:(NSString*)name count:(int)count measure:(NSString*)measure
            price:(float)price type:(NSString*)type num:(int)num date:(NSString*)date{
    if (sqlite3_open("/Users/danielmuraveyko/Google Drive/Xcode/ShopPRPS/shopDB.db",
                     &database) == SQLITE_OK){
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"dd.MM.yyyy"];
        NSDate *currentDate = [dateFormatter dateFromString:date];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *querySQL = [NSString stringWithFormat:
                @"INSERT INTO  Products (name,quantity,measurement,price,type,consignment_number, date) VALUES('%@','%d','%@','%f','%@','%d','%@')",name, count,
                              measure, price, type, num, [dateFormatter stringFromDate: currentDate]];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_step(statement);
            return 1;
        }
        else{
            NSLog(@"Error: %s", sqlite3_errmsg(database));
            sqlite3_reset(statement);
            return -1;
        }
    }
    return -1;
}


+(NSArray*)list:(NSString *)querySQL{
    NSMutableArray * resultArray = [NSMutableArray array];
    if (sqlite3_open("/Users/danielmuraveyko/Google Drive/Xcode/ShopPRPS/shopDB.db",
                     &database) == SQLITE_OK){
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *name = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:name];
                NSString *telephone = [[NSString alloc]initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 1)];
                [resultArray addObject:telephone];
                
            }
            sqlite3_reset(statement);
        }
    }
    return resultArray;
}

+(NSArray*)listOf:(NSString *)date type:(int)type{
    
    if(type == 1){
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"dd.MM"];
        NSDate *currentDate = [dateFormatter dateFromString:date];
        int daysToAdd = 10;
        NSDate *newDate = [currentDate dateByAddingTimeInterval:60*60*24*daysToAdd];
        [dateFormatter setDateFormat:@"MM-dd"];
        
        NSString *querySQL = [NSString stringWithFormat:
                              @"select FIO, telephone from Clients where strftime('%%d-%%m',Bday) between strftime('%%d-%%m','2000-%@') and strftime('%%d-%%m','2000-%@');", [dateFormatter stringFromDate: currentDate], [dateFormatter stringFromDate:newDate]];
        return [self list:querySQL];
    }
    
    if(type == 2){
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"dd.MM.yyyy"];
        NSDate *currentDate = [dateFormatter dateFromString:date];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];

        NSString *querySQL = [NSString stringWithFormat:
                        @"select DISTINCT FIO, telephone from Clients, Sells where Sells.client_id = Clients.id and Sells.date ='%@';", [dateFormatter stringFromDate: currentDate]];
        return [self list:querySQL];
    }
    
    
    return nil;
}

+(NSArray*) dynamic:(NSString *)dateFrom dateTo:(NSString*)dateTo name:(NSString*)name{
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    NSDate *dateFromForConvert = [dateFormatter dateFromString:dateFrom];
    NSDate *dateToForConvert = [dateFormatter dateFromString:dateTo];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    
    NSString *querySupply = [NSString stringWithFormat:
                          @"select sum(quantity), strftime('%%m-%%Y',date) from Products where date between '%@' and '%@' and name = '%@' group by strftime('%%m',date) ;", [dateFormatter stringFromDate: dateFromForConvert], [dateFormatter stringFromDate: dateToForConvert], name];
    NSArray * arraySupply = [self list:querySupply];
    
    NSString *querySelling = [NSString stringWithFormat:
                          @"select sum(count), strftime('%%m-%%Y',date) from Sells where date between '%@' and '%@' and product_name = '%@' group by strftime('%%m',date);",[dateFormatter stringFromDate: dateFromForConvert], [dateFormatter stringFromDate: dateToForConvert], name];
    
    NSArray * arraySelling = [self list:querySelling];
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:arraySupply];
    [result addObject:arraySelling];
    
    return result;
}

+(int)checkClient:(NSString *)name{
    if (sqlite3_open("/Users/danielmuraveyko/Google Drive/Xcode/ShopPRPS/shopDB.db",
                     &database) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:
                              @"select id from Clients where FIO='%@';", name];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                int client_id = [[[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 0)] intValue];
                
                sqlite3_reset(statement);
                return client_id;
            }
            else{
                sqlite3_reset(statement);
                return -1;
            }
            return -1;
        }
        return -1;
    }
    return -1;
}

+(int) registerSells:(NSString*)name sum:(float)sum product:(NSString*)product count:(int)count
                date:(NSString*)date client_id:(int)client_id{
    if (sqlite3_open("/Users/danielmuraveyko/Google Drive/Xcode/ShopPRPS/shopDB.db",
                     &database) == SQLITE_OK){
        //sells
        NSString *querySQL = [NSString stringWithFormat:
                              @"INSERT INTO  Sells (date,count,product_name,client_id) VALUES('%@','%d','%@','%d')",
                              date, count, product,client_id];
        const char *query_stmt1 = [querySQL UTF8String];
        sqlite3_prepare_v2(database, query_stmt1, -1, &statement, NULL);
        sqlite3_step(statement);
        
        //old clients
        querySQL = [NSString stringWithFormat:
                    @"select sum, discount from Clients where FIO = '%@'", name];
        const char *query_stmt2 = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database, query_stmt2, -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                int spent = [[[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 0)] intValue];
                int discount = [[[NSString alloc] initWithUTF8String:
                                (const char *) sqlite3_column_text(statement, 1)] intValue];
                
                bool newDiscount = FALSE;
                
                if(discount == 5){
                    if(spent + sum >= 500){
                        discount = 10;
                        newDiscount = TRUE;
                    }
                }
                else if(discount == 3){
                    if(spent + sum >= 200){
                        newDiscount = TRUE;
                        discount = 5;
                    }
                }
                else if(discount != 10 && spent + sum > 50){
                    newDiscount = TRUE;
                    discount = 3;
                }
                if(newDiscount)
                    querySQL = [NSString stringWithFormat:
                                @"update Clients set sum =sum+'%f' discount='%d' card = '%d' Where FIO = '%@'",
                                sum, discount, [self newCardNum], name];
                else
                    querySQL = [NSString stringWithFormat:
                                @"update Clients set sum =sum+'%f' Where FIO = '%@'", sum, name];

                const char *query_stmt3 = [querySQL UTF8String];
                sqlite3_prepare_v2(database, query_stmt3, -1, &statement, NULL);
                sqlite3_step(statement);
                
                if(newDiscount)
                    return discount;
            }
        }
        else{
            sqlite3_reset(statement);
            return -1;
        }
    }
    return 1;
}

+(int) registerClient:(NSString *)name date:(NSString*)date telephone:(NSString*)telephone sum:(float)sum
             p_series:(int)p_series p_number:(int)p_number p_date:(NSString*)p_date
             p_issues:(NSString*)p_issues{
    if (sqlite3_open("/Users/danielmuraveyko/Google Drive/Xcode/ShopPRPS/shopDB.db",
                     &database) == SQLITE_OK){
        
        int discount = 0;
        int cardNum = 0;
        bool newDiscount = FALSE;

        if(sum > 500){
            cardNum = [self newCardNum];
            discount = 10;
            newDiscount = TRUE;
        }
        else
            if(sum > 200){
                cardNum = [self newCardNum];
                discount = 5;
                newDiscount = TRUE;
            }
            else
                if(sum > 50){
                    cardNum = [self newCardNum];
                    discount = 3;
                    newDiscount = TRUE;
                }
        
        NSString *querySQL = [NSString stringWithFormat:
                              @"INSERT INTO  Clients (FIO,Bday,telephone,sum,discount,p_series,p_number,p_date,p_issues,card) VALUES('%@','%@','%@','%f','%d','%d','%d','%@','%@','%d')",
                              name, date, telephone, sum, discount, p_series, p_number, p_date, p_issues, cardNum];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_step(statement);
            if(newDiscount)
                return discount;
            return 1;
        }
        else{
            NSLog(@"Error: %s", sqlite3_errmsg(database));
            sqlite3_reset(statement);
            return -1;
        }
    }
    return -1;

}

@end
