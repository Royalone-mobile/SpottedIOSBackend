//
//  GamePlayerModel.h
//  spotted
//
//  Created by BoHuang on 4/12/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface GamePlayerModel : NSObject
@property (nonatomic, strong) UserModel* mUser;
@property (nonatomic, assign) long mPoint;
@property (nonatomic, strong) NSString* mPlayerState;
@property (nonatomic, strong) NSMutableArray* mBadges;
@property (nonatomic, assign) long mAnswered;

-(void) parse:(NSDictionary*) dict;
@end
