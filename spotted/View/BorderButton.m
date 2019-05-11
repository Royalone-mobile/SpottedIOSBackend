//
//  BorderButton.m
//  WeOut
//
//  Created by BoHuang on 12/21/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import "BorderButton.h"

@implementation BorderButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
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
    
}

@end
