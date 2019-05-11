//
//  NotificationViewController.h
//  spotted
//
//  Created by BoHuang on 7/13/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray* notifications;
@property (strong, nonatomic) NSMutableArray* sections;
@property (strong, nonatomic) NSMutableArray* sectionRows;
@property (weak, nonatomic) IBOutlet UITableView *tblNotifications;
@end
