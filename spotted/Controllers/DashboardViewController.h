//
//  DashboardViewController.h
//  spotted
//
//  Created by BoHuang on 4/12/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleBorderImageView.h"
#import "MainViewController.h"

@interface DashboardViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *txtDashboard;
@property (weak, nonatomic) IBOutlet UIButton *btnNotify;
@property (weak, nonatomic) IBOutlet CircleBorderImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *txtUsername;
@property (weak, nonatomic) IBOutlet UILabel *txtDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateGame;
@property (weak, nonatomic) IBOutlet UIView *viewNoGame;
@property (weak, nonatomic) IBOutlet UITableView *tblGames;
@property (strong, nonatomic) NSMutableArray *items;


@end
