//
//  SellerView.m
//  ShopPRPS
//
//  Created by Daniel Muraveyko on 30/04/2017.
//  Copyright © 2017 Daniel Muraveyko. All rights reserved.
//

#import "SellerView.h"

@interface SellerView ()
@property (weak) IBOutlet NSTextField *pDate;
@property (weak) IBOutlet NSTextField *tfProduct;
@property (weak) IBOutlet NSTextField *tfCount;
@property (weak) IBOutlet NSTextField *tfSum;
@property (weak) IBOutlet NSTextField *tfFIO;
@property (weak) IBOutlet NSTextField *pSeria;
@property (weak) IBOutlet NSTextField *pNum;
@property (weak) IBOutlet NSTextField *pIssue;
@property (weak) IBOutlet NSTextField *tfBDay;
@property (weak) IBOutlet NSTextField *tfPhone;

@property (weak) IBOutlet NSView *panelNewClient;

@end

@implementation SellerView

BOOL isNew;

- (void)viewDidLoad {
    [super viewDidLoad];
    [_panelNewClient setHidden:TRUE];
    isNew = FALSE;
}

-(BOOL)checkRegisterClient{
    if(![GlobalChecker checkEmpty:[_tfFIO stringValue]]){
        [_tfFIO setStringValue:@""];
        return FALSE;
    }
    if(![GlobalChecker checkNumber:[_tfSum stringValue]]){
        [_tfSum setStringValue:@""];
        return FALSE;
    }
    if(![GlobalChecker checkEmpty:[_tfProduct stringValue]]){
        [_tfProduct setStringValue:@""];
        return FALSE;
    }
    if(![GlobalChecker checkNumber:[_tfCount stringValue]]){
        [_tfCount setStringValue:@""];
        return FALSE;
    }
    return TRUE;
}

-(BOOL)checkNewClient{
    if(![self checkRegisterClient])
        return FALSE;
    if(![GlobalChecker checkNumber:[_pSeria stringValue]]){
        [_pSeria setStringValue:@""];
        return FALSE;

    }
    if(![GlobalChecker checkNumber:[_pNum stringValue]]){
        [_pNum setStringValue:@""];
        return FALSE;
        
    }
    if(![GlobalChecker checkEmpty:[_pIssue stringValue]]){
        [_pIssue setStringValue:@""];
        return FALSE;
        
    }
    if(![GlobalChecker checkDate:[_tfBDay stringValue]]){
        [_tfBDay setStringValue:@""];
        return FALSE;
        
    }
    if(![GlobalChecker checkNumber:[_tfPhone stringValue]]){
        [_tfPhone setStringValue:@""];
        return FALSE;
        
    }
    if(![GlobalChecker checkDate:[_pDate stringValue]]){
        [_pDate setStringValue:@""];
        return FALSE;
        
    }
    return TRUE;
}

- (IBAction)sellButtonPressed:(id)sender {
    
    int p;
   
    if(!isNew){
        if(![self checkRegisterClient]){
            [GlobalChecker alert:@"Что-то пошло не так"
                            body:@"" type:@"Warning"];
            p = 0;
            return;
        }
        else{
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            NSDate *currentDate = [NSDate date];
            [dateFormatter setDateFormat:@"dd.MM.yyyy"];
            int client_id = [DBManager checkClient:[_tfFIO stringValue]];
            if(client_id != -1)
                p = [DBManager registerSells:[_tfFIO stringValue] sum:[[_tfSum stringValue] floatValue]
                    product:[_tfProduct stringValue] count:(int)[[_tfCount stringValue] integerValue]
                    date:[dateFormatter stringFromDate:currentDate] client_id:client_id];
            else
                p = -1;
        }
        if(p == -1){
            [GlobalChecker alert:@"Ой"
                            body:@"клиент не зарегистрирован!" type:@"Warning"];

            [_panelNewClient setHidden:FALSE];
            isNew = TRUE;
            return;
        }
        else{
            if(p == 3 || p == 5 || p == 10){
                [GlobalChecker alert:@"Ого" body:[NSString stringWithFormat:
                        @"этот клиент сделал достаточно покупок для карты на %d%%!", p] type:@"norm"];
            }
         
            else {
                [GlobalChecker alert:@"Успех"
                                body:@"продажа успешно сохранена" type:@"norm"];
            }
        }
        [_tfProduct setStringValue:@""];
        [_tfCount setStringValue:@""];
        return;
    }
    
    if(![self checkNewClient]){
        [GlobalChecker alert:@"Что-то пошло не так"
                        body:@"некоторые поля пусты" type:@"Warning"];
        return;
    }
    
    p = [DBManager registerClient:[_tfFIO stringValue] date:[_tfBDay stringValue]
                        telephone:[_tfPhone stringValue] sum:[[_tfSum stringValue] floatValue]
                         p_series:[[_pSeria stringValue] intValue] p_number:[[_pNum stringValue] intValue]
                           p_date:[_pDate stringValue] p_issues:[_pIssue stringValue]];
    if(p == 1){
        [GlobalChecker alert:@"Успех"
                        body:@"клиент зарегистрирован" type:@"norm"];
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        NSDate *currentDate = [NSDate date];
        [dateFormatter setDateFormat:@"dd.MM.yyyy"];

        [DBManager registerSells:[_tfFIO stringValue] sum:[[_tfSum stringValue] floatValue]
                             product:[_tfProduct stringValue] count:(int)[[_tfCount stringValue] integerValue]
                                date:[dateFormatter stringFromDate:currentDate] client_id:[DBManager checkClient:[_tfFIO stringValue]]];
    }
    else{
        if(p == 3 || p == 5 || p == 10){
            [GlobalChecker alert:@"Ого" body:[NSString stringWithFormat:
                                              @"Этот клиент сделал достаточно покупок для карты на %d%%!", p] type:@"norm"];
        }
    }
    [_tfProduct setStringValue:@""];
    [_tfCount setStringValue:@""];
    [_panelNewClient setHidden:TRUE];
}

- (IBAction)exitButtonPressed:(id)sender {
    [self dismissViewController:self];
}

@end
