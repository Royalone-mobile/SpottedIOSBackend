//
//  PVPInfoModel.h
//  spotted
//
//  Created by BoHuang on 7/12/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVPInfoModel : NSObject
@property NSString* mUserGamesWon;
@property NSString* mUserPoint;
@property NSString* mFriendGamesWon;
@property NSString* mFriendPoint;

-(void) parse:(NSDictionary*) dict;
@end
