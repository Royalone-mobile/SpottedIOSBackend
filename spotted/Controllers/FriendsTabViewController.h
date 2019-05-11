//
//  FriendsTabViewController.h
//  spotted
//
//  Created by BoHuang on 7/12/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface FriendsTabViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,FBSDKGameRequestDialogDelegate>
@property (strong, nonatomic) NSMutableArray* friends;
@property (strong, nonatomic) NSMutableArray* sections;
@property (strong, nonatomic) NSMutableArray* sectionRows;
@property (weak, nonatomic) IBOutlet UITableView *tblFriends;
@end
