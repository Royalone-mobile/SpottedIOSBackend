//
//  DashboardViewController.m
//  spotted
//
//  Created by BoHuang on 4/12/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "DashboardViewController.h"
#import "GameTableViewCell.h"
#import "GameViewController.h"
#import "GameModel.h"
#import "FriendsViewController.h"
#import "UserInfo.h"
#import "Global.h"
#import "AFNetworking.h"
#import "NotificationModel.h"
#import "NetworkParser.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DashboardViewController ()

@end

@implementation DashboardViewController
@synthesize tblGames, txtDashboard, imgProfile, txtUsername, txtDescription, btnCreateGame, items, viewNoGame;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if(items == nil)
    {
        items = [[NSMutableArray alloc]init];
    }

    [self initView];
    [self init];

}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //set no game description show
    
    [self loadGame];
    [UserInfo shared].mCurrentScreen = @"DashboardViewController";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#progma helper

- (void) loadGame{

    UserModel* userModel = [UserInfo shared].mAccount;
    if(userModel.mId == nil)
        return;
    [[NetworkParser shared] onGetMyGames:userModel.mId  withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil){
        items = responseObject;
        }
        if(items != nil && items.count >0){
            viewNoGame.hidden = YES;
        }else {
            viewNoGame.hidden = NO;
        }
        [tblGames reloadData];
    }];

    txtUsername.text = userModel.mUserName;
    txtDescription.text = [[userModel.mFirstName stringByAppendingString:@" "] stringByAppendingString:userModel.mLastName];
    if(userModel.mPhoto != nil){
        [self.imgProfile sd_setImageWithURL:[NSURL URLWithString:userModel.mPhoto]
                 placeholderImage:[UIImage imageNamed:@"profile_ic.png"]];
    }

}
- (void) reloadGame {
    [self loadGame];
}

- (void) initView{
    tblGames.delegate = self;
    tblGames.dataSource = self;
    [tblGames registerNib:[UINib nibWithNibName:@"GameTableViewCell" bundle:nil] forCellReuseIdentifier:@"GameTableViewCell"];
    // Do any additional setup after loading the view.
    
    [self.btnNotify addTarget:self action:@selector(onNotify:) forControlEvents:UIControlEventTouchUpInside];

}

- (void) sendGameOpenNotification:(GameModel*) gameModel
{
    
    // All instances of TestClass will be notified
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"OpenGame"
     object:gameModel];
    
}
- (void) sendGameJudgeNotification:(GameModel*) gameModel
{
    
    // All instances of TestClass will be notified
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"OpenJudge"
     object:gameModel];
    
}

//#progma mark UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GameTableViewCell* cell = [self.tblGames dequeueReusableCellWithIdentifier:@"GameTableViewCell" forIndexPath:indexPath];
    
    GameModel * model = [items objectAtIndex:indexPath.row];
    cell.txtGameName.text = model.mGameName;
    cell.txtTimeRemain.text = [model getGameStatusDescription:[UserInfo shared].mAccount.mId];
    return cell;
    
    //model
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // EventTableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    GameModel * model = [items objectAtIndex:indexPath.row];
    [UserInfo shared].mCurrentGameModel = model;
    if([model checkIfJudge:[UserInfo shared].mAccount.mId]){
        [self sendGameJudgeNotification:model];
    }else {
        
        [self sendGameOpenNotification:model];
    }
    
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
// progma mark -action
- (IBAction)backAction:(id)sender{
    
}

- (IBAction)createGameAction:(id)sender {
    //create Game
    //[self serviceGameCreate];
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    FriendsViewController* vc = (FriendsViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"FriendsViewController"];
   // vc.gameModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) serviceGameCreate{
    UserModel* userModel = [UserInfo shared].mAccount;
    [Global showIndicator:self];
    [[NetworkParser shared] onGameCreate:userModel  withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil){
            GameModel* model = responseObject;
            UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            FriendsViewController* vc = (FriendsViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"FriendsViewController"];
            vc.gameModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            if([VERSION isEqualToString:@"development"]){
                [Global AlertMessage:self Message:responseObject Title:@"Reason"];
            }
        }
        [Global stopIndicator:self];
    }];
}

- (id) init
{
    self = [super init];
    if (!self) return nil;

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveGameNotification:)
                                                 name:@"GameNotification"
                                               object:nil];
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
        if([[UserInfo shared].mCurrentScreen isEqualToString:@"DashboardViewController"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadGame];
            });
        }
    
    }
}


- (void) receiveGameNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"GameNotification"])
    {
        //get notification and change the notification icon.
        [self changeNotificationIcon];
        
    }
}

- (void) changeNotificationIcon{
    if([UserInfo shared].mNotifications.count > 0){
        [self.btnNotify setImage:[UIImage imageNamed:@"notify_received_ic.png"] forState:UIControlStateNormal];
    }else{
        [self.btnNotify setImage:[UIImage imageNamed:@"notification_ic.png"] forState:UIControlStateNormal];
    }
    
    
}

- (void) onNotify:(id) obj{

    if([UserInfo shared].mNotifications.count>0){
        
        NotificationModel* model = [UserInfo shared].mNotifications[0];
        [self showAlertOnNotify: [model getNotificationTitle] withMessage:[model getNotificationMessage]];
        [[UserInfo shared].mNotifications removeObject:model];
        
    }
}
- (void) onSignOut:(id) obj{
    [[UserInfo shared] setLogined:false];
    [Global switchScreen:self.parentViewController withControllerName:@"LoginViewController"];
}

- (void) showAlertOnNotify :(NSString*) title withMessage:(NSString*) message{
     UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleActionSheet]; // 1
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
          }]; // 2
    
    [alert addAction:ok];
    if([alert popoverPresentationController] != nil){
        [alert setModalPresentationStyle:UIModalPresentationPopover];
        [alert popoverPresentationController].sourceView = self.btnNotify;
        [alert popoverPresentationController].sourceRect =  self.btnNotify.bounds;
    }
    [self presentViewController:alert animated:YES completion:nil]; // 6
}

//Mark: - IBActions
- (IBAction)shareAction:(id)sender {
    [Global shareApp:self withButtonView: sender];
}




@end
