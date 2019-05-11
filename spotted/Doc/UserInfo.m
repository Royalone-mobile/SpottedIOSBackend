//
//  UserInfo.m
//  FitMusic
//
//  Created by BoHuang on 7/20/16.
//  Copyright © 2016 Jong. All rights reserved.
//


#import "UserInfo.h"
#import "macros.h"

//Userdefault Keys

static NSString * kDefaultLoginedKey = @"LOGINSTATE";
static NSString * kDefaultUserId = @"USERID";
static NSString * kDefaultFBToken = @"FBToken";
@implementation UserInfo

+ (instancetype)shared
{
    static UserInfo *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UserInfo alloc] init];
        
    });
    
    return sharedInstance;
}

-(id) init{
    self = [super init];
    if(self != nil)
    {
        self.mAccount = [[UserModel alloc] init];
        self.mNotifications = [[NSMutableArray alloc] init];
        self.mCurrentScreen = @"";
        self.mCurrentScreenProfile = @"";
        [self loadDefaults];
    }
    return self;
}
-(void) logOut
{
    [self setLogined:false];
}

- (void)saveDefaults:(NSString *)key value:(id)obj
{
    if (obj != nil)
       UDSetValue(key, obj);
    else
       UDRemove(key);
       UDSync();
}

-(void) loadDefaults
{
    self.mAccount.mId = UDValue(kDefaultUserId);
}

-(void) setLogined:(bool)logined
{

    UDSetBool(kDefaultLoginedKey, logined);
    UDSync();
}

-(bool) getLogined {
    return UDBool(kDefaultLoginedKey);
}
-(void) setUserId:(NSString*)userId
{
    UDSetValue(kDefaultUserId, userId);
    UDSync();
}
-(NSString*) getUserId{
    return UDValue(kDefaultUserId);
}

-(void) setFacebookToken:(NSString*) token{
    UDSetValue(kDefaultFBToken, token);
    UDSync();
}

-(NSString*) getFacebookToken{
    return UDValue(kDefaultFBToken);
}


-(void) setViewRoundResult:(NSString*) gameId withRoundIndex:(NSString*) roundIndex{
    NSString* key = gameId;
    NSString* value = roundIndex;
    UDSetValue(key, value);
}
- (NSString*) getLastSawRoundIndex:(NSString*) gameId {
    return UDValue(gameId);
}
@end
