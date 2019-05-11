//
//  MainViewController.h
//  spotted
//
//  Created by BoHuang on 4/11/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>


@interface MainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *tabDashboard;
@property (weak, nonatomic) IBOutlet UIButton *tabProfile;
@property (weak, nonatomic) IBOutlet UIButton *tabFriends;
@property (weak, nonatomic) IBOutlet UIButton *tabShare;
@property (weak, nonatomic) IBOutlet UIButton *tabNotification;
@property (weak, nonatomic) IBOutlet UIButton *tabHowTo;
@property (weak, nonatomic) IBOutlet UIButton *tabPrivacyPolicy;

@property (strong, nonatomic) UIViewController* currentViewController;
@property (strong, nonatomic) UIViewController* dashboardViewController;
@property (strong, nonatomic) UIViewController* profileViewController;
@property (strong, nonatomic) UIViewController* friendsTabViewController;
@property (strong, nonatomic) UIViewController* gameViewController;
@property (strong, nonatomic) UIViewController* profileEditViewController;
@property (strong, nonatomic) UIViewController* gameSetupViewController;
@property (strong, nonatomic) UIViewController* notificationViewController;
@property (strong, nonatomic) UIViewController* howtoViewController;
@property (strong, nonatomic) UIViewController* privacyPolicyViewController;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;

@property (assign, nonatomic) int selectedTag;

@property (weak, nonatomic) IBOutlet UILabel *txtDashboard;
@property (weak, nonatomic) IBOutlet UILabel *txtProfile;
@property (weak, nonatomic) IBOutlet UILabel *txtFriends;
@property (weak, nonatomic) IBOutlet UILabel *txtShare;
@property (weak, nonatomic) IBOutlet UILabel *txtNotification;
@property (weak, nonatomic) IBOutlet UILabel *txtHowTo;
@property (weak, nonatomic) IBOutlet UILabel *txtPrivacyPolicy;

@property (weak, nonatomic) IBOutlet UIView *moreNav;

@end
