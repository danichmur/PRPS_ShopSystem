//
//  bDateView.m
//  ShopPRPS
//
//  Created by Daniel Muraveyko on 30/04/2017.
//  Copyright © 2017 Daniel Muraveyko. All rights reserved.
//

#import "bDateView.h"

@interface bDateView ()

@property (weak) IBOutlet NSTextField *tfDate;
@property (unsafe_unretained) IBOutlet NSTextView *tfField;


@end

@implementation bDateView

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)btPrintPressed:(id)sender {
    if(![GlobalChecker checkDate:[_tfDate stringValue]]){
        [GlobalChecker alert:@"Что-то пошло не так"
                        body:@"" type:@"Warning"];
        [_tfDate setStringValue:@""];
        return;
    }
    NSArray * result = [DBManager listOf:[_tfDate stringValue] type:2];
    NSMutableString *s = [NSMutableString stringWithCapacity:10];
    [s appendFormat:@"Всего: %lu\n", (unsigned long)[result count] / 2];
    
    for(int i = 0; i < [result count]; i+= 2){
        [s appendFormat:@"%@ %@\n", result[i], result[i + 1]];
    }
    [_tfField setString:s];
}

- (IBAction)btExitPressed:(id)sender {
    [self dismissViewController:self];
}

@end
