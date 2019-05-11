//
//  GamePlayerSetupTableViewCell.h
//  spotted
//
//  Created by BoHuang on 4/18/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderView.h"

@interface GamePlayerSetupTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *txtName;
@property (weak, nonatomic) IBOutlet UILabel *txtWinRound;
@property (weak, nonatomic) IBOutlet BorderView *viewJudge;
@property (weak, nonatomic) IBOutlet UIButton *btnRemove;
@end
