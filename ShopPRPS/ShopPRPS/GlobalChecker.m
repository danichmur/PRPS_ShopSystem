//
//  GlobalChecker.m
//  ShopPRPS
//
//  Created by Daniel Muraveyko on 01/05/2017.
//  Copyright © 2017 Daniel Muraveyko. All rights reserved.
//

#import "GlobalChecker.h"

@implementation GlobalChecker

+(BOOL)checkNumber:(NSString*)s {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    NSNumber *myNumber = [f numberFromString:s];
    if(myNumber == nil)
        return FALSE;
    return TRUE;
    
}

+(BOOL)checkEmpty:(NSString*)s{
    if(s.length == 0)
        return FALSE;
    return TRUE;
}

+(BOOL)checkDate:(NSString*)s{
    if(s.length != 10)
        return FALSE;
    if(![self checkNumber: [s substringWithRange:NSMakeRange(0, 2)]] ||
       ![self checkNumber: [s substringWithRange:NSMakeRange(3, 2)]] ||
       ![self checkNumber: [s substringWithRange:NSMakeRange(6, 4)]]
       )
        return FALSE;
    if([s characterAtIndex:2] != '.' || [s characterAtIndex:5] != '.')
        return FALSE;
    return TRUE;
}

+(void)alert:(NSString*)title body:(NSString*)body type:(NSString*)type{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:title];
    [alert setInformativeText:body];
    [alert addButtonWithTitle:@"OK"];

    if([type isEqualToString:@"Warning"])
        [alert setIcon: [NSImage imageNamed:@"Image"]];
    else
        [alert setIcon: [NSImage imageNamed:@"Ok"]];
    [alert runModal];

}

@end
