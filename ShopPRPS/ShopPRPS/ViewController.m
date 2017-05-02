//
//  ViewController.m
//  ShopPRPS
//
//  Created by Daniel Muraveyko on 29/04/2017.
//  Copyright © 2017 Daniel Muraveyko. All rights reserved.
//

#import "ViewController.h"
#import "GlobalChecker.h"

@implementation ViewController

NSMutableArray *_items;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)entryButtonPressed:(id)sender {
    if(![GlobalChecker checkEmpty:[_tfLogin stringValue]]
       || ![GlobalChecker checkEmpty:[_tfPassword stringValue]]){
        [GlobalChecker alert:@"Что-то пошло не так" body:@"некоторые поля пусты" type:@"Warning"];
        return;
    }
    
    int p = [DBManager findByLoginAndPassword : [_tfLogin stringValue]
                                     password : [_tfPassword stringValue]];

    switch (p) {
        case 1:
            [self performSegueWithIdentifier:@"showManagerView" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"showSellerView" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"showStoragekeeperView" sender:self];
            break;
        default:
            [GlobalChecker alert:@"Что-то пошло не так" body:@"такой пользователь не обнаружен" type:@"Warning"];
            break;
    }
}

@end


