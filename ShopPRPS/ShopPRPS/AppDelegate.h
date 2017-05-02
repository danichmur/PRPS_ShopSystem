//
//  AppDelegate.h
//  ShopPRPS
//
//  Created by Daniel Muraveyko on 29/04/2017.
//  Copyright © 2017 Daniel Muraveyko. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;


@end

