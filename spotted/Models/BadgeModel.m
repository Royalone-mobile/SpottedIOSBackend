//
//  BadgeModel.m
//  spotted
//
//  Created by BoHuang on 4/17/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "BadgeModel.h"
#import "Global.h"
@implementation BadgeModel
-(void) parse:(NSDictionary*) dict{
    
    if (self) {
        if([dict objectForKey:@"_id"] != nil)
        {
            self.mId = (NSString*)[dict objectForKey:@"_id"];
        }
        
        if ([dict objectForKey:@"badgeName"] != nil) {
            self.mName = (NSString*)[dict objectForKey:@"badgeName"];
        }
 
        if ([dict objectForKey:@"imageUrl"] != nil) {
            self.mImageUrl = [UPLOAD_URL stringByAppendingString: (NSString*)[dict objectForKey:@"imageUrl"]];
        }
        
        
        if ([dict objectForKey:@"description"] != nil) {
            self.mDescription = (NSString*)[dict objectForKey:@"description"];
        }
        
             
    }
    
}
@end
