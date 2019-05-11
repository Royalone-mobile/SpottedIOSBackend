//
//  LoginViewController.h
//  spotted
//
//  Created by BoHuang on 4/11/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderButton.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateNew;	

@property (strong, nonatomic) FBSDKLoginButton* loginButton;

@end
