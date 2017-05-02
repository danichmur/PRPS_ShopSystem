//
//  Storagekeeper.m
//  ShopPRPS
//
//  Created by Daniel Muraveyko on 30/04/2017.
//  Copyright © 2017 Daniel Muraveyko. All rights reserved.
//

#import "Storagekeeper.h"

@interface Storagekeeper ()

@property (weak) IBOutlet NSTextField *tfName;
@property (weak) IBOutlet NSTextField *tfCount;
@property (weak) IBOutlet NSPopUpButton *pubMeasure;
@property (weak) IBOutlet NSTextField *price;
@property (weak) IBOutlet NSPopUpButton *pubType;
@property (weak) IBOutlet NSTextField *tbNum;
@property (weak) IBOutlet NSTextField *tfDate;

@end

@implementation Storagekeeper


- (void)viewDidLoad {
    [super viewDidLoad];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSDate *currentDate = [NSDate date];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    [_tfDate setStringValue: [dateFormatter stringFromDate:currentDate]];
    
}

- (IBAction)addProductButtonPressed:(id)sender {
    
    int p;
    if(![GlobalChecker checkEmpty:[_tfName stringValue]] ||
       ![GlobalChecker checkEmpty:[_tfCount stringValue]] ||
       ![GlobalChecker checkEmpty:[_price stringValue]]  ||
       ![GlobalChecker checkNumber:[_tbNum stringValue]])
        p = 0;
    else
        p = [DBManager addProduct : [_tfName stringValue] count:[_tfCount intValue]
            measure: [_pubMeasure titleOfSelectedItem] price: [_price floatValue]
            type: [_pubType titleOfSelectedItem] num:[_tbNum intValue] date:[_tfDate stringValue]];
    
    if(p == 1){
        [_tfName setStringValue:@""];
        [_tfCount setStringValue:@""];
        [_price setStringValue:@""];
        [_tbNum setStringValue:@""];
        [GlobalChecker alert:@"Успех"
                        body:@"товар успешно добавлен" type:@"norm"];
    }
    else{
        [GlobalChecker alert:@"Что-то пошло не так"
                        body:@"некоторые поля пусты" type:@"Warning"];
    }
}

- (IBAction)exitButtonPressed:(id)sender {
    [self dismissViewController:self];
}

@end
