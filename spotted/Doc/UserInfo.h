//
//  UserInfo.h
//  FitMusic
//
//  Created by BoHuang on 7/20/16.
//  Copyright © 2016 Jong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "UserInfo.h"
#import "GameModel.h"
#import "SocketIOHandler.h"
#import <UIKit/UIKit.h>	

@interface UserInfo : NSObject

@property (nonatomic, strong) UserModel * mAccount;
@property (nonatomic, strong) UIViewController* mSavedController;
@property (nonatomic, strong) NSMutableArray * mNotifications;
@property (nonatomic, strong) GameModel * mCurrentGameModel;
@property (nonatomic, strong) NSString* mCurrentScreen;
@property (nonatomic, strong) NSString* mCurrentScreenProfile;


+ (instancetype)shared;
-(void) loadDefaults;
-(void) setUserId:(NSString*)userId;
-(void) setLogined:(bool)logined;
-(NSString*) getUserId;
-(bool) getLogined;
-(void) setFacebookToken:(NSString*) token;
-(NSString*) getFacebookToken;
-(void) setViewRoundResult:(NSString*) gameId withRoundIndex:(NSString*) roundIndex;
- (NSString*) getLastSawRoundIndex:(NSString*) gameId;

@end
