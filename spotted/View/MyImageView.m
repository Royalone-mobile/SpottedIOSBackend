//
//  MyImageView.m
//  FoodSafety
//
//  Created by BoHuang on 9/15/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "MyImageView.h"


@implementation MyImageView

@dynamic borderColor,borderWidth;
-(void)setBorderColor:(UIColor *)borderColor{
    [self.layer setBorderColor:borderColor.CGColor];
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    [self.layer setBorderWidth:borderWidth];
}

-(void) layoutSubviews{
    [super layoutSubviews];
    //self.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.contentMode = UIViewContentModeScaleAspectFill;
    
    self.clipsToBounds = YES;
}
@end
