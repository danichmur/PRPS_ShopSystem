//
//  ManagerView.m
//  ShopPRPS
//
//  Created by Daniel Muraveyko on 30/04/2017.
//  Copyright © 2017 Daniel Muraveyko. All rights reserved.
//

#import "ManagerView.h"

@interface ManagerView ()

@end

@implementation ManagerView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

}

- (IBAction)sellsDynamics:(id)sender {
    [self performSegueWithIdentifier:@"showDynamics" sender:self];
}

- (IBAction)clientsWithDiscount:(id)sender {
    [self performSegueWithIdentifier:@"showDiscount" sender:self];
}

- (IBAction)clientsWithBDay:(id)sender {
    [self performSegueWithIdentifier:@"showBDay" sender:self];
}

- (IBAction)exit:(id)sender {
    [self dismissViewController:self];
}

@end
