//
//  HTPViewController.m
//  spotted
//
//  Created by BoHuang on 4/17/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "HTPViewController.h"
#import "FriendsViewController.h"
#import "Global.h"

@interface HTPViewController ()


@end

@implementation HTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:HOW_TO_PLAY_URL]];
    [self.webView setOpaque:NO];
    self.webView.backgroundColor = [UIColor clearColor];
    [self.webView loadRequest:urlRequest];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#progma mark - action
- (IBAction)btnPlayNow:(id)sender {
    /*UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    FriendsViewController* vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"FriendsViewController"];
    vc.screenCase =@"IMPORT_SCREEN";
    [self.navigationController pushViewController:vc animated:YES];*/
    [Global switchScreen:self withControllerName:@"MainViewController"];
}

@end
