//
//  GameViewController.m
//  spotted
//
//  Created by BoHuang on 4/12/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "GameViewController.h"
#import "GamePlayerModel.h"
#import "GamePlayerTableViewCell.h"
#import "Global.h"
#import "UserInfo.h"
#import "NetworkParser.h"
#import "BadgeModel.h"
#import "BadgeCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GameViewController ()

@end

@implementation GameViewController
@synthesize txtNavigationTitle, btnBack, btnAlert, txtRemainingTime, tblPlayers, txtTaskTitle, txtTask, btnCamera, items, badgeItems, badgesViewGroup, collectionBadges, refreshControl;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(items == nil)
    {
        items = [[NSMutableArray alloc]init];
    }
    
    [self initView];
    [self init];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [UserInfo shared].mCurrentScreen = @"GameViewController";
    currentScreen = @"GameViewController";
    [self loadGame];
}

//#progma helper

- (void) loadGame{

    
    
    
    if(self.gameModel != nil){
        items = self.gameModel.mGamePlayers;
        [tblPlayers reloadData];
    }
    if(self.gameModel.mCurrentRound != nil){
        txtRemainingTime.text    = [self.gameModel.mCurrentRound getRemainingTimeString];
    }
    
    txtNavigationTitle.text = self.gameModel.mGameName;
    
    [self.photoSubmitted setHidden:YES];

    if([[self.gameModel getGamePlayerState:[UserInfo shared].mAccount.mId] isEqualToString:@"losed"]){
        int ranking = [self.gameModel getRanking:[UserInfo shared].mAccount.mId];
        if(ranking > 1){
            NSString* myNewString = [NSString stringWithFormat:@"%i", ranking];
            self.txtTaskTitle.text = @"You Placed";
            self.txtTask.text = myNewString;
            self.txtTaskTitle.hidden =false;
            self.txtTask.hidden = false;
            self.taskView.hidden = true;
            [self showCameraButton:NO];
            GamePlayerModel* playerModel = [self.gameModel getGamePlayerModel:[UserInfo shared].mAccount.mId];
            if(playerModel.mBadges.count > 0){
                [self showBadgeCollection:YES];
                badgeItems = playerModel.mBadges;
                [collectionBadges reloadData];
            }else{
                [self showBadgeCollection:NO];
            }
                  return;
        }
  
        
    }
    if([self.gameModel.mStatus isEqualToString:@"close"]){
        self.txtTaskTitle.hidden =false;
        self.txtTask.hidden = false;
        if( self.gameModel.mGameWinner.mId == nil){
            self.txtTaskTitle.text = @"Game Over";
            self.txtTask.text = @"";
            
        }else {
            int ranking = [self.gameModel getRanking:[UserInfo shared].mAccount.mId];
            if(ranking == 1) {
                self.txtTaskTitle.text = @"Congratulations";
                self.txtTask.text = @"You won the game";
            
            }else if(ranking > 0){
                NSString* myNewString = [NSString stringWithFormat:@"%i", ranking];
                self.txtTaskTitle.text = @"You Placed";
                self.txtTask.text = myNewString;
            }
        }
        
        self.taskView.hidden = true;
        GamePlayerModel* playerModel = [self.gameModel getGamePlayerModel:[UserInfo shared].mAccount.mId];
        if(playerModel.mBadges.count > 0){
            [self showBadgeCollection:YES];
            badgeItems = playerModel.mBadges;
            [collectionBadges reloadData];
        }else{
            [self showBadgeCollection:NO];
        }
        [self showCameraButton:NO];
        
      
        
        return;
        
    }
    [self showBadgeCollection:NO];
    if([self.gameModel isJudger:[UserInfo shared].mAccount.mId]){
        if(self.gameModel.mCurrentRound.mTask != nil){
            NSString* task =self.gameModel.mCurrentRound.mTask;
            self.txtTask.text = [@"Spotted: " stringByAppendingString: task];
            self.txtTaskTitle.hidden =false;
            self.txtTask.hidden = false;
            self.taskView.hidden = true;
            
            
        }else {
            self.txtTask.text = @"";
            self.taskView.hidden = false;
            self.txtTaskTitle.hidden =true;
            self.txtTask.hidden = true;
        }
        [self showCameraButton:NO];
        
    }else {
        if(self.gameModel.mCurrentRound.mTask != nil){
            NSString* task =self.gameModel.mCurrentRound.mTask;
            self.taskView.hidden = true;
            self.txtTaskTitle.hidden =false;
            self.txtTask.hidden = false;
            
            self.txtTaskTitle.text = [@"ROUND " stringByAppendingString:self.gameModel.mCurrentRound.mRoundIndex];
            self.txtTask.text =[@"Spotted: " stringByAppendingString:task];
            [self showCameraButton:YES];
            if([self.gameModel checkIfSubmitAnswer:[UserInfo shared].mAccount.mId]){
                [self.btnCamera setHidden:YES];
                [self.photoSubmitted setHidden:NO];
                [self.imgCamera setHidden:YES];
            }else {
                [self.btnCamera setHidden:NO];
                [self.photoSubmitted setHidden:YES];
                [self.imgCamera setHidden:NO];
            }
        }else {
            self.taskView.hidden = true;
            self.txtTaskTitle.hidden =false;
            self.txtTask.hidden = false;
            self.txtTaskTitle.text = [@"ROUND " stringByAppendingString:self.gameModel.mCurrentRound.mRoundIndex];
            self.txtTask.text = @"Waiting for task.";
            [self showCameraButton:NO];
        }
        
        
    }

}

- (void) reloadGame {
    if(self.gameModel != nil){
        [Global showIndicator:self];
        [[NetworkParser shared] onGetGame:self.gameModel.mId withCompletionBlock:^(id responseObject, NSString *error) {
            if(error == nil){
                self.gameModel = responseObject;
                [UserInfo shared].mCurrentGameModel = self.gameModel;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadGame];
                });
            }
            [Global stopIndicator:self];
        }];
    }
}
- (void)refreshTable {
    //TODO: refresh your data
    [refreshControl endRefreshing];
    [self reloadGame];
}
- (void) attendActions{
    [btnBack addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnAlert addTarget:self action:@selector(alertAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnCamera addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnTaskWrite addTarget:self action:@selector(taskWriteAction:) forControlEvents:UIControlEventTouchUpInside];

}
- (void) initView{
    tblPlayers.delegate = self;
    tblPlayers.dataSource = self;
    [self attendActions];
    [tblPlayers registerNib:[UINib nibWithNibName:@"GamePlayerTableViewCell" bundle:nil] forCellReuseIdentifier:@"GamePlayerTableViewCell"];
    // Do any additional setup after loading the view.
   [collectionBadges registerNib:[UINib nibWithNibName:@"BadgeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BadgeCollectionViewCell"];
    badgeItems = [[NSMutableArray alloc] init];
    _spacing = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(time) userInfo:nil repeats:YES];
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tblPlayers addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];

}

- (id) init
{
    self = [super init];
    if (!self) return nil;
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveUpdateNotification:)
                                                 name:@"UpdateScreen"
                                               object:nil];
    
    return self;
}

- (void) receiveUpdateNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"UpdateScreen"])
    {
        if([[UserInfo shared].mCurrentScreen isEqualToString:@"GameViewController"]){
          //  dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadGame];
          //  });

        }
        
    }
}


//program mark -actions
-(void)time
{
    
    if(self.gameModel == nil || [UserInfo shared].mAccount == nil )
        return;
    if([[self.gameModel getGamePlayerState:[UserInfo shared].mAccount.mId] isEqualToString:@"losed"] || [self.gameModel.mStatus isEqualToString:@"close"]){
        txtRemainingTime.text    = [self.gameModel.mCurrentRound timeFormatted:0];
        return;
    }
   
    if(self.gameModel != nil && self.gameModel.mCurrentRound != nil){
        
        txtRemainingTime.text    = [self.gameModel.mCurrentRound getRemainingTimeString];
    }
    
}
- (void) sendDashboardOpenNotification{
    
    // All instances of TestClass will be notified
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"OpenDashboard"
     object:nil];
    
}
- (IBAction)leaveGame:(id)sender {
  
    GamePlayerModel* model = [self.gameModel getGamePlayerModel:  [UserInfo shared].mAccount.mId];
    
    if([model.mUser.mId isEqualToString:self.gameModel.mGameCreator.mId])
    {
        return;
    }
    if (self.gameModel.mGamePlayers.count <= MIN_PLAYERS) {
        NSString* title= @"Alert";
        NSString* message = @"If you leave this game will be over. Do you want to leave this game?";
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:title
                                     message:message
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"Ok"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //delete game.
                                       [[NetworkParser shared] onGameOver:self.gameModel.mId withCompletionBlock:^(id responseObject, NSString *error) {
                                           [[NetworkParser shared] onRemovePlayer:model.mUser.mId withGameId:self.gameModel.mId withCompletionBlock:^(id responseObject, NSString *error) {
                                               [self sendDashboardOpenNotification];
                                               
                                           }];

                                           
                                       }];
                                       
                                       
                                   }];
        
        UIAlertAction* cancelButton = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction * action) {
                                           
                                       }];
        [alert addAction:okButton];
        [alert addAction:cancelButton];
        
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if(self.gameModel.mGamePlayers.count > MIN_PLAYERS){
        [Global ConfirmWithCompletionBlock:self Message:@"Do you want to leave this game?" Title:@"Alert" withCompletion:^(NSString *result) {
            if([result isEqualToString:@"Ok"]){
                [[NetworkParser shared] onRemovePlayer:model.mUser.mId withGameId:self.gameModel.mId withCompletionBlock:^(id responseObject, NSString *error) {
                    [items removeObject:model];
                    [tblPlayers reloadData];
                    
                }];
            }
        }];
        
    }

    
}

- (void) backAction:(id) obj{
    [self sendDashboardOpenNotification];
}

- (void) alertAction:(id) obj{
}

- (void) cameraAction:(id) obj{
    if([self.gameModel checkIfSubmitAnswer:[UserInfo shared].mAccount.mId]){
        [Global AlertMessage:self Message:@"You already submitted your Answer." Title:@"Alert"];
    }else {
        if(![currentScreen isEqualToString:@"CameraViewController"]) {
            [Global switchScreen:self withControllerName:@"CameraViewController"];
        }
    }
    
}
- (IBAction)logoutAction:(id)sender {
    
    [Global shareApp:self withButtonView:sender];
}

- (void) taskWriteAction:(id) obj{
    [self showTaskWriteAlert];
}

- (void) showTaskWriteAlert {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Write Task"
                                                                              message: @"Describe what you want other players to take a picture of and send to you."
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        NSString* task = namefield.text;
        if([task isEqualToString:@""]){
            return;
        }
        [[NetworkParser shared] onWriteTask:self.gameModel.mId withUserId:[UserInfo shared].mAccount.mId withTask:task withCompletionBlock:^(id responseObject, NSString *error) {
            if(error == nil){
                txtTask.text = [@"Spotted: " stringByAppendingString: task];
                self.txtTaskTitle.text = [@"ROUND " stringByAppendingString:self.gameModel.mCurrentRound.mRoundIndex];
                self.taskView.hidden = true;
                self.txtTask.hidden = false;
                self.txtTaskTitle.hidden = false;
                [self reloadGame];

            }else{
                if([VERSION isEqualToString:@"development"]){
                    [Global AlertMessage:self Message:responseObject Title:@"Reason"];
                }
            }
        }];
        
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}


//#progma mark UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GamePlayerTableViewCell* cell = [self.tblPlayers dequeueReusableCellWithIdentifier:@"GamePlayerTableViewCell" forIndexPath:indexPath];
      
    GamePlayerModel * model = [items objectAtIndex:indexPath.row];
    if(self.gameModel != nil){
        cell.viewJudge.hidden = ![self.gameModel isJudger:model.mUser.mId];
           }
    cell.txtName.text = model.mUser.mUserName;
    cell.txtWinRound.text = [[NSNumber numberWithLong:model.mPoint] stringValue];;
    
 
    return cell;
    
    //model
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (void) showCameraButton :(BOOL) visible {
   /* NSLayoutConstraint *heightConstraint;
    for (NSLayoutConstraint *constraint in self.cameraView.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            heightConstraint = constraint;
            break;
        }
    }*/
    
    if(visible){
       // heightConstraint.constant = 90;
        [self.cameraView setHidden:NO];
    }else {
        //heightConstraint.constant = 90;
        [self.cameraView setHidden:YES];
    }
}

- (void) showBadgeCollection :(BOOL) visible {
    NSLayoutConstraint *heightConstraint;
    for (NSLayoutConstraint *constraint in self.badgesViewGroup.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            heightConstraint = constraint;
            break;
        }
    }
    
    if(visible){
        heightConstraint.constant = 150;
                self.badgesViewGroup.hidden = false;
    }else {
        heightConstraint.constant = 0;
                self.badgesViewGroup.hidden = true;
    }
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
    return 0;
}



//progma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}



@end
