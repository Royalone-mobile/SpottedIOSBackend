//
//  PVPInfoModel.m
//  spotted
//
//  Created by BoHuang on 7/12/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "PVPInfoModel.h"

@implementation PVPInfoModel
-(void) parse:(NSDictionary*) dict{
    
    if (self) {
        if([dict objectForKey:@"userWon"] != nil)
        {
            long value = [[dict objectForKey:@"userWon"] integerValue];
            self.mUserGamesWon = [NSString stringWithFormat:@"%ld", value];
        }
        if([dict objectForKey:@"friendWon"] != nil)
        {
            long value = [[dict objectForKey:@"friendWon"] integerValue];
            self.mFriendGamesWon = [NSString stringWithFormat:@"%ld", value];
        }
        if([dict objectForKey:@"userPoint"] != nil)
        {
            long value = [[dict objectForKey:@"userPoint"] integerValue];
            self.mUserPoint = [NSString stringWithFormat:@"%ld", value];
        }
        if([dict objectForKey:@"friendPoint"] != nil)
        {
            long value = [[dict objectForKey:@"friendPoint"] integerValue];
            self.mFriendPoint = [NSString stringWithFormat:@"%ld", value];
        }
    }
    
}
@end
