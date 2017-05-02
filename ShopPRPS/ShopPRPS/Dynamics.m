//
//  Dynamics.m
//  ShopPRPS
//
//  Created by Daniel Muraveyko on 30/04/2017.
//  Copyright © 2017 Daniel Muraveyko. All rights reserved.
//

#import "Dynamics.h"

@interface Dynamics ()
@property (weak) IBOutlet NSTextField *tbProduct;
@property (weak) IBOutlet NSTextField *tfDateFrom;
@property (weak) IBOutlet NSTextField *tfDateTo;
@property (unsafe_unretained) IBOutlet NSTextView *tfField;


@end

@implementation Dynamics


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}
- (IBAction)btPrintPressed:(id)sender {
    if(![GlobalChecker checkDate:[_tfDateFrom stringValue]]){
        [GlobalChecker alert:@"Что-то пошло не так"
                        body:@"" type:@"Warning"];
        [_tfDateFrom setStringValue:@""];
        return;
    }
    if(![GlobalChecker checkDate:[_tfDateTo stringValue]]){
        [GlobalChecker alert:@"Что-то пошло не так"
                        body:@"" type:@"Warning"];
        [_tfDateTo setStringValue:@""];
        return;
    }
    if(![GlobalChecker checkEmpty:[_tbProduct stringValue]]){
        [GlobalChecker alert:@"Что-то пошло не так"
                        body:@"" type:@"Warning"];
        [_tbProduct setStringValue:@""];
        return;
    }
    NSArray * result = [DBManager dynamic:[_tfDateFrom stringValue]
                                   dateTo:[_tfDateTo stringValue] name:[_tbProduct stringValue]];
    NSMutableString *s = [NSMutableString stringWithCapacity:10];
    
    if([result[0] count] != 0){
        [s appendString:@"Поступило:\n"];
        for(int i = 0; i < [result[0] count]; i+= 2){
            [s appendFormat:@"%@: %@\n", result[0][i+1], result[0][i]];
        }
    }
    if([result[1] count] != 0){
        [s appendString:@"Продано:\n"];
        for(int i = 0; i < [result[1] count]; i+= 2){
            [s appendFormat:@"%@: %@\n", result[1][i+1], result[1][i]];
        }
    }
    if([s length] == 0)
        [s appendString: @"Товар не обнаружен, либо товар не поставлялся и не продавался."];
    [_tfField setString:s];
}

- (IBAction)btExitPressed:(id)sender {
    [self dismissViewController:self];
}

@end
