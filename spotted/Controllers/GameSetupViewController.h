//
//  GameSetupViewController.h
//  spotted
//
//  Created by BoHuang on 4/18/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameModel.h"
#import "BorderButton.h"
#import "Global.h"

@interface GameSetupViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UILabel *txtNavigationTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnAlert;
@property (weak, nonatomic) IBOutlet UILabel *txtRemainingTime;
@property (weak, nonatomic) IBOutlet UITableView *tblPlayers;
@property (weak, nonatomic) IBOutlet UILabel *txtTaskTitle;
@property (weak, nonatomic) IBOutlet UILabel *txtTask;

@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) GameModel * gameModel;
@property (weak, nonatomic) IBOutlet UIView *taskView;
@property (weak, nonatomic) IBOutlet UIButton *btnRename;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIButton *btnTask;
@property (weak, nonatomic) IBOutlet BorderButton *tbnCamera;
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIView *badgesViewGroup;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionBadges;
@property (weak, nonatomic) IBOutlet UILabel *badgesTitle;
@property (strong, nonatomic) NSMutableArray *badgeItems;
@property (weak, nonatomic) IBOutlet UILabel *photoSubmitted;
@property (weak, nonatomic) IBOutlet UIImageView *imgCamera;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property(assign, nonatomic) NSInteger spacing;
@property (nonatomic, strong) NSTimer * timer;

@end
