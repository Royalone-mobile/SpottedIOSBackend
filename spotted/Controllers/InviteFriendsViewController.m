//
//  InviteFriendsViewController.m
//  spotted
//
//  Created by BoHuang on 7/1/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "Global.h"

@interface InviteFriendsViewController ()

@end

@implementation InviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)shareAction:(id)sender {
    
    [Global shareApp:self withButtonView:sender];
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
