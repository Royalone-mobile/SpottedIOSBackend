//
//  TPViewController.m
//  spotted
//
//  Created by BoHuang on 4/17/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "TPViewController.h"
#import "Global.h"
#import "UserInfo.h"

@interface TPViewController ()

@end

@implementation TPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:PRIVACY_POLICY_URL]];
    [self.webView setOpaque:NO];
    self.webView.backgroundColor = [UIColor clearColor];
    [self.webView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action

- (IBAction)decline:(id)sender {
   
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Are you sure?"
                                 message:@"If you decline, you will not be able to play the game."
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* declineButton = [UIAlertAction
                               actionWithTitle:@"Decline"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   [Global switchScreen:self withControllerName:@"LoginViewController"];
                                   [[UserInfo shared] setLogined:false];
                               }];
    UIAlertAction* cancel = [UIAlertAction
                                    actionWithTitle:@"Cancel"
                                    style:UIAlertActionStyleCancel
                                    handler:^(UIAlertAction * action) {
                            }];
    
    [alert addAction:declineButton];
    
    [alert addAction:cancel];
    
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)accept:(id)sender {
    [Global switchScreen:self withControllerName:@"HTPViewController"];
}



@end
