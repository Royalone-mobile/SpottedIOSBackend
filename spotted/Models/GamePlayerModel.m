//
//  GamePlayerModel.m
//  spotted
//
//  Created by BoHuang on 4/12/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "GamePlayerModel.h"
#import "BadgeModel.h"
@implementation GamePlayerModel
- (id)init
{
    if((self = [super init])) {
        self.mUser = [[UserModel alloc] init];
        self.mBadges = [[NSMutableArray alloc] init];
        self.mPoint = 0;
        self.mPlayerState = @"beforeAnswer";
    }
    return self;
}

-(void) parse:(NSDictionary*) dict{
    
    if (self) {
        if([dict objectForKey:@"player"] != nil)
        {
            NSDictionary* player = [dict objectForKey:@"player"];
            [self.mUser parse:player];
        }
        
        if([dict objectForKey:@"point"] != nil)
        {
            self.mPoint = [[dict objectForKey:@"point"] longValue];
            
        }
        if([dict objectForKey:@"answered"] != nil)
        {
            self.mAnswered= [[dict objectForKey:@"answered"] longValue];
            
        }
        if([dict objectForKey:@"playerState"] != nil){
            self.mPlayerState = (NSString*)[dict objectForKey:@"playerState"];
        }
        
        if([dict objectForKey:@"badges"] != nil){
            NSDictionary* badgeData = (NSDictionary*)[dict objectForKey:@"badges"];
            for(NSDictionary* item in badgeData)
            {
                if([item isKindOfClass:[NSDictionary class]]){
                    BadgeModel* newModel = [[BadgeModel alloc] init];
                    [newModel parse:item];
                    [self.mBadges addObject:newModel];
                }		
            }
        }
    
    }
    
}

@end
