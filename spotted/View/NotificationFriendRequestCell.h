//
//  NotificationFriendRequestCell.h
//  spotted
//
//  Created by BoHuang on 7/13/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleBorderImageView.h"

@interface NotificationFriendRequestCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnDecline;
@property (weak, nonatomic) IBOutlet UIButton *btnAccept;
@property (weak, nonatomic) IBOutlet CircleBorderImageView *imgRequester;
@property (weak, nonatomic) IBOutlet UILabel *labRequesterName;
@property (weak, nonatomic) IBOutlet UILabel *labRequestText;

@end
