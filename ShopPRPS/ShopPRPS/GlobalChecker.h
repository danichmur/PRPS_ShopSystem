//
//  GlobalChecker.h
//  ShopPRPS
//
//  Created by Daniel Muraveyko on 01/05/2017.
//  Copyright © 2017 Daniel Muraveyko. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GlobalChecker : NSObject

+(BOOL)checkNumber:(NSString*)s;
+(BOOL)checkEmpty:(NSString*)s;
+(BOOL)checkDate:(NSString*)s;
+(void)alert:(NSString*)title body:(NSString*)body type:(NSString*)type;

@end
