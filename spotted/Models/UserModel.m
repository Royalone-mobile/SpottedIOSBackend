//
//  UserModel.m
//  spotted
//
//  Created by BoHuang on 4/11/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "UserModel.h"
#import "BadgeModel.h"
#import "Global.h"

@implementation UserModel


- (id)init
{
    if((self = [super init])) {
        self.mBadges = [[NSMutableArray alloc] init];
        self.mUserName = @"";
        self.mFirstName = @"";
        self.mLastName = @"";
        self.mEmail = @"";
        self.mWins   = 0;
        self.mPlays = 0;
        self.mPoints = 0;
        self.mOnline = @"online";
         
        
    }
    return self;
}

-(void) parse:(NSDictionary*) dict{
    
    if (self) {
        if([dict objectForKey:@"_id"] != nil)
        {
            self.mId = (NSString*)[dict objectForKey:@"_id"];
        }
        
        if ([dict objectForKey:@"firstName"] != nil) {
            self.mUserName = (NSString*)[dict objectForKey:@"firstName"];
        }
        if ([dict objectForKey:@"lastName"] != nil) {
            
        }
        if ([dict objectForKey:@"point"] != nil) {
            
            self.mPoints = [[dict objectForKey:@"point"] longValue];
        }
        if ([dict objectForKey:@"gamesWon"] != nil) {
            self.mWins = [[dict objectForKey:@"gamesWon"] longValue];
        }
        if ([dict objectForKey:@"gamesPlayed"] != nil) {
            self.mPlays = [[dict objectForKey:@"gamesPlayed"] longValue];
        }
        
        if ([dict objectForKey:@"imageUrl"] != nil) {

            self.mPhoto = [UPLOAD_URL stringByAppendingString: (NSString*)[dict objectForKey:@"imageUrl"]];
        }
        
        
        if ([dict objectForKey:@"email"] != nil) {
            self.mEmail = (NSString*)[dict objectForKey:@"email"];
        }
        
        
        if ([dict objectForKey:@"online"] != nil) {
            self.mOnline = (NSString*)[dict objectForKey:@"online"];
        }
        if ([dict objectForKey:@"facebookId"] != nil) {
            self.mFacebookId = (NSString*)[dict objectForKey:@"facebookId"];
        }
        
        if([dict objectForKey:@"badges"] != nil){
            [self.mBadges removeAllObjects];
            	
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
