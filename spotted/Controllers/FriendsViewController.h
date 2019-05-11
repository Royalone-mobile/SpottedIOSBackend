//
//  FriendsViewController.h
//  spotted
//
//  Created by BoHuang on 4/12/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameModel.h"
#import "BorderButton.h"

@interface FriendsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) GameModel *gameModel;


@property (weak, nonatomic) IBOutlet UIButton *btnInvite;
@property (weak, nonatomic) IBOutlet UITableView *tblFriends;
@property (strong, nonatomic) NSMutableArray* friends;
@property (strong, nonatomic) NSMutableArray* sections;
@property (strong, nonatomic) NSMutableArray* sectionRows;

@property (weak, nonatomic) IBOutlet UIView *viewInvite;
@property (weak, nonatomic) IBOutlet UIView *viewDash;
@property (strong, nonatomic) IBOutlet NSMutableArray* lstContacts;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;


@end
