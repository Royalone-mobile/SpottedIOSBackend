//
//  ForgotPasswordViewController.m
//  spotted
//
//  Created by BoHuang on 6/19/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "NetworkParser.h"
#import "Global.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (bool) validateData {
    if(![Global NSStringIsValidEmail:self.txtEmail.text]){
        [Global AlertMessage:self Message:@"Please enter email." Title:@"Alert"];
        return false;
    }
    return true;
}
- (IBAction)submitAction:(id)sender {
    if([self validateData]){
        
        [[NetworkParser shared] onForgotPassword:self.txtEmail.text withCompletionBlock:^(id responseObject, NSString *error) {
            if(error == nil){
                [Global AlertMessage:self Message:@"Your new password sent to your email." Title:@"Success"];
            }else{
                [Global AlertMessage:self Message:error Title:@"Reason"];
            }
        }];
    }
}
- (IBAction)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
