//
//  UserModel.h
//  spotted
//
//  Created by BoHuang on 4/11/17.
//  Copyright © 2017 ITLove. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, strong) NSString* mId;
@property (nonatomic, strong) NSString* mUserName;
@property (nonatomic, strong) NSString* mFirstName;
@property (nonatomic, strong) NSString* mLastName;
@property (nonatomic, strong) NSString* mPhoto;
@property (nonatomic, strong) NSString* mEmail;
@property (nonatomic, strong) NSString* mPassword;
@property (nonatomic, strong) NSString* mFacebookId;
@property (nonatomic, strong) NSString* mOnline;
@property (nonatomic, strong) NSString* mToken;
@property long mWins;
@property long mPoints;
@property long mPlays;
@property (nonatomic, strong) NSMutableArray* mBadges;
@property bool registered;
@property (nonatomic, strong) NSString* mContactSource;
@property (nonatomic, strong) NSString* mPhoneNumber;

-(void) parse:(NSDictionary*) dict;
@end


