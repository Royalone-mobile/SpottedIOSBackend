//
//  ProfileViewController.h
//  spotted
//
//  Created by BoHuang on 4/12/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleBorderImageView.h"
#import "BorderButton.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>



@interface ProfileViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout, FBSDKAppInviteDialogDelegate>
@property (weak, nonatomic) IBOutlet CircleBorderImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *txtName;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet BorderButton *btnConnectFacebook;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionBadges;
@property (weak, nonatomic) IBOutlet UILabel *txtGamePlayed;
@property (weak, nonatomic) IBOutlet UILabel *txtGameWon;
@property (weak, nonatomic) IBOutlet UILabel *txtPoints;
@property (strong, nonatomic) NSMutableArray *badgeItems;
@property (assign, nonatomic) UIEdgeInsets  sectionInsects;
@property(assign, nonatomic) NSInteger spacing;

@end
