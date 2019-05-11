//
//  GameViewController.h
//  spotted
//
//  Created by BoHuang on 4/12/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameModel.h"
@interface GameViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *txtNavigationTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnAlert;
@property (weak, nonatomic) IBOutlet UILabel *txtRemainingTime;
@property (weak, nonatomic) IBOutlet UITableView *tblPlayers;
@property (weak, nonatomic) IBOutlet UIButton *btnTaskWrite;
@property (weak, nonatomic) IBOutlet UILabel *txtTaskTitle;
@property (weak, nonatomic) IBOutlet UILabel *txtTask;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (strong, nonatomic) NSMutableArray *items;
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIView *taskView;
@property (weak, nonatomic) IBOutlet UIView *badgesViewGroup;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionBadges;
@property (weak, nonatomic) IBOutlet UILabel *badgesTitle;
@property (strong, nonatomic) GameModel * gameModel;
@property (strong, nonatomic) NSMutableArray *badgeItems;
@property (assign, nonatomic) NSInteger spacing;
@property (weak, nonatomic) IBOutlet UILabel *photoSubmitted;
@property (weak, nonatomic) IBOutlet UIButton *btnLeaveGame;
@property (weak, nonatomic) IBOutlet UIImageView *imgCamera;
@property (nonatomic, strong) NSTimer * timer;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end
