//
//  BdayView.m
//  ShopPRPS
//
//  Created by Daniel Muraveyko on 01/05/2017.
//  Copyright © 2017 Daniel Muraveyko. All rights reserved.
//

#import "BdayView.h"

@interface BdayView ()

@property (unsafe_unretained) IBOutlet NSTextView *tfField;

@property (weak) IBOutlet NSTextField *tfDate;

@end

@implementation BdayView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (IBAction)printButtonPressed:(id)sender {
    if(![GlobalChecker checkEmpty:[_tfDate stringValue]]){
        [GlobalChecker alert:@"Что-то пошло не так"
                        body:@"" type:@"Warning"];
        [_tfDate setStringValue:@""];
        return;
    }
    NSArray * result = [DBManager listOf:[_tfDate stringValue] type:1];
    NSMutableString *s = [NSMutableString stringWithCapacity:10];
    [s appendString:@"Клиенты c Днём рождения в ближайшие 10 дней:\n"];
    if([result count] == 0){
        [_tfField setString:@"Клиенты с Днём рождения в ближайшие 10 дней не найдены"];
        return;
    }
    for(int i = 0; i < [result count]; i+= 2){
        [s appendFormat:@"%@ %@\n", result[i], result[i + 1]];
    }
    [_tfField setString:s];

}

- (IBAction)exitButtonPressed:(id)sender {
    [self dismissViewController:self];
}

@end
