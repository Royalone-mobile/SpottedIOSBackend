//
//  SplashViewController.m
//  spotted
//
//  Created by BoHuang on 4/11/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "SplashViewController.h"
#import "Global.h"
#import "UserInfo.h"
#import "AFNetworking.h"
#import "NetworkParser.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SocketIOHandler shared];
    if([[UserInfo shared] getLogined]){
        [self getUserInfo];

    }else {
        [self gotoLogin];
    }
 
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];  
}

- (void)gotoLogin {
    [Global switchScreen:self withControllerName:@"LoginViewController"];
    //[Global switchScreen:self withControllerName:@"CameraViewController"];
}

- (void)gotoMain{
    [Global switchScreen:self withControllerName:@"MainViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateToken {
    UserModel* account = [UserInfo shared].mAccount;
    if(account.mId != nil
       && ![account.mId isEqualToString:@""]
       && account.mToken != nil
       && ![account.mToken isEqualToString: @""]){
        
        [Global showIndicator:self];
        [[NetworkParser shared] onUpdateAPNSToken:account.mToken withUserId:account.mId withCompletionBlock:^(id responseObject, NSString *error) {
            [Global stopIndicator:self];
            		
        }];      
    }
}

- (void) getUserInfo {

    UserModel* account = [[UserInfo shared] mAccount];
    if([[UserInfo shared] getLogined] && account.mId != nil && ![account.mId isEqualToString:@""]){
        [[NetworkParser shared] onGetUserInfo:account.mId withCompletionBlock:^(id responseObject, NSString *error) {
            if(error == nil){
                [self updateToken];
                [self gotoMain];
            }else {
                [[UserInfo shared] setLogined:false];
                [self gotoLogin];
            }
        }];
    }else{
        [self gotoLogin];
        return;
    }

}

@end
