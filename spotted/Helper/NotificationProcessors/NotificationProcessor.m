//
//  NotificationProcessor.m
//  spotted
//
//  Created by BoHuang on 6/1/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "NotificationProcessor.h"
#import "NotificationModel.h"
#import "ProcessorFactory.h"

@implementation NotificationProcessor

+ (instancetype)shared
{
    static NotificationProcessor *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NotificationProcessor alloc] init];
        
    });
    
    return sharedInstance;
}

- (void) process:(NSDictionary *)payload{
    NotificationModel* notificationModel= [[NotificationModel alloc] init];
    [notificationModel parse: payload];
    
    ProcessorFactory* factory = [[ProcessorFactory alloc] init];
    Processor* processor = [factory createProcessor:notificationModel.mType];
    if(processor != nil) {
        [processor process:payload];
    }

    
}
@end
