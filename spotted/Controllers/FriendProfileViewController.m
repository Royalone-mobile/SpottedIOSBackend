//
//  FriendProfileViewController.m
//  spotted
//
//  Created by BoHuang on 7/12/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "FriendProfileViewController.h"
#import "FriendsViewController.h"
#import "BadgeModel.h"
#import "BadgeCollectionViewCell.h"
#import "NetworkParser.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserInfo.h"
#import "Global.h"
#import "PVPInfoModel.h"

@interface FriendProfileViewController ()

@end

@implementation FriendProfileViewController
@synthesize imgProfile, txtName, collectionBadges, txtGamePlayed, txtGameWon, txtPoints, badgeItems;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    _spacing = 0;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// load data

- (void)loadData {
    //load pvp infos
    [self getUserInfo];
    
    badgeItems = self.model.mUser.mBadges;
    [collectionBadges reloadData];
    
}

- (void) getUserInfo {
    if(self.model == nil || self.model.mUser == nil)
        return;
    [Global showIndicator:self];
    NSString* userId = [UserInfo shared].mAccount.mId;
    [[NetworkParser shared] onGetPVPInfos:userId withFriendId:self.model.mUser.mId withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil){
             PVPInfoModel* model =(PVPInfoModel*) responseObject;
            if(model !=nil && model.mUserGamesWon != nil){
                self.youGamePlayed.text = model.mUserGamesWon;
                self.youPoint.text = model.mUserPoint;
                self.friendGamePlayed.text = model.mFriendGamesWon;
                self.friendPoint.text = model.mFriendPoint;

            }
        }
        [Global stopIndicator:self];
       
        
    }];
    
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UserModel* account = self.model.mUser;
    txtName.text = account.mUserName;
    txtPoints.text =  [NSString stringWithFormat:@"%ld",account.mPoints] ;
    txtGameWon.text = [NSString stringWithFormat:@"%ld",account.mWins] ;
    txtGamePlayed.text = [NSString stringWithFormat:@"%ld",account.mPlays] ;
    self.friendName.text = account.mUserName;
    [self.imgProfile sd_setImageWithURL:[NSURL URLWithString:account.mPhoto ]
                       placeholderImage:[UIImage imageNamed:@"splash_back.png"]];
    [self loadData];
    
}
//progma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return badgeItems.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BadgeModel* model = [self.badgeItems objectAtIndex:indexPath.row];
    NSString *identifier = @"BadgeCollectionViewCell";
    
    BadgeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.txtBadgeName setText:model.mName];
    [((UIImageView *)cell.badgeImage) sd_setImageWithURL:[NSURL URLWithString:model.mImageUrl] placeholderImage:[UIImage imageNamed:@"splash_back.png"]];
    return cell;
}
//progma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(90, 128);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    NSInteger cellCount = [collectionView.dataSource collectionView:collectionView numberOfItemsInSection:section];
    if( cellCount >1 )
    {
        CGFloat cellWidth = ((UICollectionViewFlowLayout*)collectionViewLayout).itemSize.width+((UICollectionViewFlowLayout*)collectionViewLayout).minimumInteritemSpacing;
        CGFloat totalCellWidth = cellWidth*cellCount + _spacing*(cellCount-1);
        CGFloat contentWidth = collectionView.frame.size.width-collectionView.contentInset.left-collectionView.contentInset.right;
        if( totalCellWidth<contentWidth )
        {
            CGFloat padding = (contentWidth - totalCellWidth) / 2.0;
            return UIEdgeInsetsMake(0, padding, 0, padding);
        }
    }else if(cellCount == 1) {
        //CGFloat cellWidth = ((UICollectionViewFlowLayout*)collectionViewLayout).itemSize.width;
        CGFloat cellWidth= 90;
        CGFloat totalCellWidth = cellWidth*cellCount + _spacing*(cellCount-1);
        CGFloat contentWidth = collectionView.frame.size.width-collectionView.contentInset.left-collectionView.contentInset.right;
        if( totalCellWidth<contentWidth )
        {
            CGFloat padding = (contentWidth - totalCellWidth) / 2.0;
            return UIEdgeInsetsMake(0, padding, 0, padding);
        }
    }
    return UIEdgeInsetsZero;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return self.sectionInsects.left;
}
// progma mark -helper
- (void) initView{
    collectionBadges.dataSource = self;
    collectionBadges.delegate = self;
    
    
    self.sectionInsects = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [collectionBadges registerNib:[UINib nibWithNibName:@"BadgeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BadgeCollectionViewCell"];
}


//progma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}


@end
