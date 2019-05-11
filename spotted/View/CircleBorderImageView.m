//
//  CircleBorderImageView.m
//  spotted
//
//  Created by BoHuang on 4/12/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "CircleBorderImageView.h"

@implementation CircleBorderImageView

@dynamic borderColor,borderWidth;
-(void)setBorderColor:(UIColor *)borderColor{
    [self.layer setBorderColor:borderColor.CGColor];
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    [self.layer setBorderWidth:borderWidth];
}

-(void) layoutSubviews{
    [super layoutSubviews];
    self.layer.cornerRadius = self.layer.frame.size.height /2;
    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
}

@end


