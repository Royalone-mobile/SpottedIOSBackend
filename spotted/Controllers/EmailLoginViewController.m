//
//  EmailLoginViewController.m
//  spotted
//
//  Created by BoHuang on 4/24/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "EmailLoginViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "Global.h"
#import "UserModel.h"
#import "UserInfo.h"
#import "AFNetworking.h"
#import "NetworkParser.h"

@interface EmailLoginViewController ()

@end

@implementation EmailLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if([VERSION isEqualToString:@"development"]){
        self.txtEmail.text = @"test@mail.com";
        self.txtPassword.text = @"password";
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loginWithEmail :(NSString*) email withPassword:(NSString*) password {
    //TODO implement Api to login
    UserModel* account = [[UserInfo shared] mAccount];
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString:LOGIN];
    
    NSURL *URL = [NSURL URLWithString:serverurl];
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];

    [objects addObject:email];
    [keys addObject:@"email"];
    [objects addObject:password];
    [keys addObject:@"password"];
    if(account.mToken != nil && ![account.mToken isEqualToString:@""]){
        [objects addObject:account.mToken];
        [keys addObject:@"APNSToken"];
    }
    
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [Global showIndicator:self];
    [manager POST:URL.absoluteString parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary* dict = (NSDictionary*)responseObject;
        NSDictionary* user = (NSDictionary*)[dict objectForKey:@"user"];
        [account parse:user];
        account.mOnline = @"true";
        [[UserInfo shared] setLogined:true];
        [[UserInfo shared] setUserId:account.mId];
        [self updateToken];
        [self gotoMain];
        
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


- (void) gotoMain {
    [Global switchScreen:self withControllerName:@"MainViewController"];
}
- (IBAction)loginAction:(id)sender {
    if([self.txtEmail.text isEqualToString:@""]){
        [Global AlertMessage:self Message:@"Please enter email." Title:@"Alert"];
    }else if([self.txtPassword.text isEqualToString:@""]){
        [Global AlertMessage:self Message:@"Please enter password." Title:@"Alert"];
    }
    [self loginWithEmail:self.txtEmail.text withPassword:self.txtPassword.text];
}
- (IBAction)createAccountAction:(id)sender {
       [self gotoSignUp];
}
- (IBAction)signUpWithFacebookAction:(id)sender {
        [self fblogin];
}

- (void) gotoSignUp {
    [Global switchScreen:self withControllerName:@"SignUpViewController"];
}

// progam mark -facebook login

-(void)fblogin{
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    if ([UIApplication.sharedApplication canOpenURL:[NSURL URLWithString:@"fb://"]])
    {
        login.loginBehavior = FBSDKLoginBehaviorSystemAccount;
    }
    [Global showIndicator:self];
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

- (IBAction)forgetAction:(id)sender {
        [Global switchScreen:self withControllerName:@"ForgotPasswordViewController"];	
}
/*
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == nameField) {
        [textField resignFirstResponder];
        [emailField becomeFirstResponder];
    } else if (textField == emailField) {
        // here you can define what happens
        // when user presses return on the email field
    }
    return YES;
}
 */
@end
