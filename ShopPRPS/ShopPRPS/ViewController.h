//
//  ViewController.h
//  ShopPRPS
//
//  Created by Daniel Muraveyko on 29/04/2017.
//  Copyright © 2017 Daniel Muraveyko. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DBManager.h"
#import "ManagerView.h"
#import "SellerView.h"

@interface ViewController : NSViewController

@property (weak) IBOutlet NSTextField *tfLogin;
@property (weak) IBOutlet NSSecureTextField *tfPassword;
//@property NSWindowController *managerView;
//@property NSWindowController *authenticationView;
//@property NSStoryboard *storyBoard;

@end

