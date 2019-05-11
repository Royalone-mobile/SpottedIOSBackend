//
//  FriendTableViewCell.h
//  spotted
//
//  Created by BoHuang on 4/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgCheck;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *txtName;
@property (weak, nonatomic) IBOutlet UILabel *txtOnline;
@property (weak, nonatomic) IBOutlet UIButton *btnViewProfile;

@end
