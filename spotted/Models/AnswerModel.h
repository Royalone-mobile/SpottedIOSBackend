//
//  AnswerModel.h
//  spotted
//
//  Created by BoHuang on 4/13/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface AnswerModel : NSObject
@property NSString* mId;
@property NSString* mImageUrl;
@property NSString* mUserId;

-(void) parse:(NSDictionary*) dict;

-(UserModel*) getAnswerOwner;
@end
