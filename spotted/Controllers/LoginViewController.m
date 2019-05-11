//
//  LoginViewController.m
//  spotted
//
//  Created by BoHuang on 4/11/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "LoginViewController.h"
#import "Global.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "UserModel.h"
#import "UserInfo.h"
#import "AFNetworking.h"
#import "NetworkParser.h"
@interface LoginViewController ()

@end


@implementation LoginViewController
@synthesize  btnLogin, btnCreateNew;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
    }
    self.loginButton = [[FBSDKLoginButton alloc] init];
    self.loginButton.hidden = YES;
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// progma mark -helper
- (void) initView{
    
    [self attendActions];


}

- (void) attendActions{
    [btnLogin addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnCreateNew addTarget:self action:@selector(createNewAccount:) forControlEvents:UIControlEventTouchUpInside];
}


- (void) loginWithEmail :(NSString*) email withPassword:(NSString*) password {
    //TODO implement Api to login
    
    [self gotoMain];
}
- (void) gotoEmailLogin {
       [Global switchScreen:self withControllerName:@"EmailLoginViewController"];
}

- (void) gotoSignUp {
    [Global switchScreen:self withControllerName:@"SignUpViewController"];
}

- (void) gotoMain {
    [Global switchScreen:self withControllerName:@"MainViewController"];
}

// progma mark -actions
- (void) loginAction:(id) obj{
    [self gotoEmailLogin];


}
- (void) createNewAccount:(id) obj{
    [self gotoSignUp];
    
}

- (IBAction)loginFBAction:(id)sender {
     [self fblogin];
}

// progam mark -facebook login

-(void)fblogin{
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    if ([UIApplication.sharedApplication canOpenURL:[NSURL URLWithString:@"fb://"]])
    {
        login.loginBehavior = FBSDKLoginBehaviorSystemAccount;
    }
    [Global showIndicator:self];
    [login logOut];
    [login logInWithReadPermissions:@[@"public_profile", @"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error)
        {
            [Global stopIndicator:self];
            NSLog(@"Unexpected login error: %@", error);
            NSString *alertMessage = error.userInfo[FBSDKErrorLocalizedDescriptionKey] ?: @"There was a problem logging in. Please try again later.";
            NSString *alertTitle = error.userInfo[FBSDKErrorLocalizedTitleKey] ?: @"Oops";
            [[[UIAlertView alloc] initWithTitle:alertTitle
                                        message:alertMessage
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            
        }
        else
        {
            if(result.token)   // This means if There is current access token.
            {
                [[UserInfo shared] setFacebookToken:result.token.tokenString];
                
                [self facebookLogin:result.token.tokenString];
                [Global stopIndicator:self];
            }else{
                [Global stopIndicator:self];
            }
            NSLog(@"Login Cancel");
        }
    }];
}

- (void) facebookLogin :(NSString*) facebookToken{
    //TODO implement Api to login
    UserModel* account = [[UserInfo shared] mAccount];
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString:FACEBOOK_LOGIN];
    
    NSURL *URL = [NSURL URLWithString:serverurl];
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    [objects addObject:facebookToken];
    [keys addObject:@"access_token"];

    if(account.mToken != nil && ![account.mToken isEqualToString:@""]){
        [objects addObject:account.mToken];
        [keys addObject:@"APNSToken"];
    }
    
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [Global showIndicator:self];
    [manager GET:URL.absoluteString parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary* dict = (NSDictionary*)responseObject;
        NSDictionary* user = (NSDictionary*)[dict objectForKey:@"user"];
        [account parse:user];
        account.mOnline = @"true";
        [[UserInfo shared] setLogined:true];
        [[UserInfo shared] setUserId:account.mId];
        [self updateToken];
        [Global stopIndicator:self];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        
        NSError *jsonError;
        NSData *objectData = [errResponse dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&jsonError];
        NSLog(@"%@", errResponse);
        if(jsonError == nil){
            if([json valueForKey:@"reason"]){
                NSString* reason = [json valueForKey:@"reason"];
                [Global AlertMessage:self Message:reason Title:@"Reason"];
            }
        }
        [Global stopIndicator:self];
        
    }];
    
    
}
- (void) updateToken {
    UserModel* account = [[UserInfo shared] mAccount];
    if(account.mId != nil
       && ![account.mId isEqualToString:@""]
       && account.mToken != nil
       && ![account.mToken isEqualToString: @""]){
        
        [Global showIndicator:self];
        [[NetworkParser shared] onUpdateAPNSToken:account.mToken withUserId:account.mId withCompletionBlock:^(id responseObject, NSString *error) {
            [Global stopIndicator:self];
            [self gotoMain];
        }];
    }
}

// progma mark -Api call
@end
