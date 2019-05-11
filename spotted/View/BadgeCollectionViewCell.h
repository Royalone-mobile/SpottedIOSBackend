//
//  BadgeCollectionViewCell.h
//  spotted
//
//  Created by BoHuang on 4/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleBorderImageView.h"
#import "BorderView.h"

@interface BadgeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet CircleBorderImageView *badgeImage;
@property (weak, nonatomic) IBOutlet BorderView *badgeView;
@property (weak, nonatomic) IBOutlet UILabel *txtBadgeName;

@end
