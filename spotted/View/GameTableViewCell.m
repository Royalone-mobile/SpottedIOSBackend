//
//  GameTableViewCell.m
//  spotted
//
//  Created by BoHuang on 4/12/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "GameTableViewCell.h"

@implementation GameTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
        self.backgroundColor = [UIColor clearColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
