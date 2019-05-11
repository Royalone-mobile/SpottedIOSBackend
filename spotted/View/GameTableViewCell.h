//
//  GameTableViewCell.h
//  spotted
//
//  Created by BoHuang on 4/12/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *txtGameName;
@property (weak, nonatomic) IBOutlet UILabel *txtTimeRemain;

@end
