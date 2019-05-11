//
//  FriendProfileViewController.h
//  spotted
//
//  Created by BoHuang on 7/12/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleBorderImageView.h"
#import "BorderButton.h"
#import "FriendTableCellModel.h"
@interface FriendProfileViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet CircleBorderImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *txtName;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionBadges;
@property (weak, nonatomic) IBOutlet UILabel *txtGamePlayed;
@property (weak, nonatomic) IBOutlet UILabel *txtGameWon;
@property (weak, nonatomic) IBOutlet UILabel *txtPoints;
@property (strong, nonatomic) NSMutableArray *badgeItems;
@property (assign, nonatomic) UIEdgeInsets  sectionInsects;
@property(assign, nonatomic) NSInteger spacing;
@property (strong, nonatomic) FriendTableCellModel* model;

@property (weak, nonatomic) IBOutlet UILabel *friendName;

@property (weak, nonatomic) IBOutlet UILabel *youGamePlayed;
@property (weak, nonatomic) IBOutlet UILabel *friendGamePlayed;
@property (weak, nonatomic) IBOutlet UILabel *youPoint;
@property (weak, nonatomic) IBOutlet UILabel *friendPoint;


@end
