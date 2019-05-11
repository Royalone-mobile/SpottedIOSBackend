//
//  GamePlayerTableViewCell.h
//  spotted
//
//  Created by BoHuang on 4/12/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderView.h"

@interface GamePlayerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *txtName;
@property (weak, nonatomic) IBOutlet UILabel *txtWinRound;
@property (weak, nonatomic) IBOutlet BorderView *viewJudge;

@end
