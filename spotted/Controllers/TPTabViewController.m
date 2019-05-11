//
//  TPTabViewController.m
//  spotted
//
//  Created by BoHuang on 10/16/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "TPTabViewController.h"
#import "Global.h"
#import "UserInfo.h"

@interface TPTabViewController ()

@end

@implementation TPTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:PRIVACY_POLICY_URL]];
    [self.webView setOpaque:NO];
    self.webView.backgroundColor = [UIColor clearColor];
    [self.webView loadRequest:urlRequest];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
