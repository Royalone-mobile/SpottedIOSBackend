//
//  AddNewFriendsViewController.h
//  spotted
//
//  Created by BoHuang on 7/12/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderButton.h"

@interface AddNewFriendsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (weak, nonatomic) IBOutlet BorderButton *btnSearch;
@property (weak, nonatomic) IBOutlet UITableView *tblFriends;
@property (strong, nonatomic) NSMutableArray* friends;
@property (strong, nonatomic) NSMutableArray* sections;
@property (strong, nonatomic) NSMutableArray* sectionRows;
@end
