//
//  DBManager.h
//  ShopPRPS
//
//  Created by Daniel Muraveyko on 30/04/2017.
//  Copyright © 2017 Daniel Muraveyko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject
{
    NSString *databasePath;
}

+(DBManager*)getSharedInstance;

+(int) findByLoginAndPassword:(NSString*)login password:(NSString*)password;
+(int) addProduct:(NSString*)name count:(int)count measure:(NSString*)measure
            price:(float)price type:(NSString*)type num:(int)num date:(NSString*)date;
+(int) registerSells:(NSString*)name sum:(float)sum product:(NSString*)product count:(int)count
                date:(NSString*)date client_id:(int)client_id;
+(int) registerClient:(NSString *)name date:(NSString*)date telephone:(NSString*)telephone sum:(float)sum
             p_series:(int)p_series p_number:(int)p_number p_date:(NSString*)p_date
             p_issues:(NSString*)p_issues;
+(int) checkClient:(NSString *)name;
+(NSArray*) listOf:(NSString *)date type:(int)type;
+(NSArray*) dynamic:(NSString *)dateFrom dateTo:(NSString*)dateTo name:(NSString *)name;

@end
