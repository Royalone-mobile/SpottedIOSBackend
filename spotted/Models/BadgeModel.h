//
//  BadgeModel.h
//  spotted
//
//  Created by BoHuang on 4/17/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BadgeModel : NSObject
@property NSString* mId;
@property NSString* mImageUrl;
@property NSString* mName;
@property NSString* mDescription;

-(void) parse:(NSDictionary*) dict;
@end
