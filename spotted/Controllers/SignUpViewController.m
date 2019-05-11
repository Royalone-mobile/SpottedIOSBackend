//
//  SignUpViewController.m
//  spotted
//
//  Created by BoHuang on 4/11/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "SignUpViewController.h"
#import "Global.h"
#import "UserModel.h"
#import "UserInfo.h"
#import "AFNetworking.h"
#import "NetworkParser.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface SignUpViewController ()

@end


@implementation SignUpViewController

@synthesize txtName, txtEmail, txtPassword, txtRetypePassword, btnCreateAccount, btnLogin;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// progma mark -helper
- (void) initView{
    if([VERSION isEqualToString:@"development"]){
        txtEmail.text = @"test@mail.com";
        txtPassword.text = @"password";
        txtRetypePassword.text = @"password";
        txtName.text = @"test";
    }
    [self attendActions];
}


- (void) attendActions{
    [btnLogin addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnCreateAccount addTarget:self action:@selector(createAccountAction:) forControlEvents:UIControlEventTouchUpInside];

}

- (void) gotoLogin {
    [Global switchScreen:self withControllerName:@"LoginViewController"];
}

- (void) gotoMain {
    [Global switchScreen:self withControllerName:@"TPViewController"];
}


// progma mark -actions
- (void) loginAction:(id) obj{
    [self gotoLogin];
}
- (IBAction)forgotPasswordAction:(id)sender {
    [Global switchScreen:self withControllerName:@"ForgotPasswordViewController"];
}

- (void) createAccountAction:(id) obj{
    if([txtName.text isEqualToString:@""] ) {
        [Global AlertMessage:self Message:@"Please enter nickname." Title:@"Alert"];
        return;
    } else if(![Global NSStringIsValidEmail:txtEmail.text]){
        [Global AlertMessage:self Message:@"Please enter email." Title:@"Alert"];
        return;
    }else if([txtPassword.text isEqualToString:@""]){
        [Global AlertMessage:self Message:@"Please enter password."
                       Title:@"Alert"];
        return;
    }else if([txtRetypePassword.text isEqualToString:@""]){
        [Global AlertMessage:self Message:@"Please enter confirm password." Title:@"Alert"];
        return;
    }else if(![txtPassword.text isEqualToString:txtRetypePassword.text]){
        [Global AlertMessage:self Message:@"Password and RetypePassword is not the same." Title:@"Alert"];
        return;
    }
    [self signup:txtName.text withEmail: txtEmail.text withPassword:txtPassword.text ];
    
    //[self gotoLogin];
}

// progma mark -signup
- (void) signup:(NSString*)username withEmail:(NSString*)email withPassword:(NSString*)password {
    UserModel* account = [[UserInfo shared] mAccount];
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString:PLAYERS];
    
    NSURL *URL = [NSURL URLWithString:serverurl];
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [objects addObject:username];
    [keys addObject:@"firstName"];
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
        [account parse:dict];
        [[UserInfo shared] setLogined:true];
        [[UserInfo shared] setUserId:account.mId];
        account.mOnline = @"true";
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

// progam mark -facebook login

- (IBAction)signUpWithFacebookAction:(id)sender {
    [self fblogin];
}

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


@end
