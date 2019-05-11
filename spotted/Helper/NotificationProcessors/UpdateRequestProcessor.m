//
//  InviteRequestProcessor.m
//  spotted
//
//  Created by BoHuang on 6/1/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "UpdateRequestProcessor.h"
#import "NotificationModel.h"
#import "NetworkParser.h"
#import "UserInfo.h"
#import <UIKit/UIKit.h>

@implementation UpdateRequestProcessor

-(void)process:(NSDictionary*)payload{
    
    NotificationModel* notificationModel= [[NotificationModel alloc] init];
    [notificationModel parse: payload];
    self.model = notificationModel;
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"UpdateScreen"
     object:nil];
    
}

@end
