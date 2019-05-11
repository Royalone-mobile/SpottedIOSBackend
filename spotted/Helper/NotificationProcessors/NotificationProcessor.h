//
//  NotificationProcessor.h
//  spotted
//
//  Created by BoHuang on 6/1/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationProcessor : NSObject
+ (instancetype)shared;
-(void) process:(NSDictionary*) payload;
@end
