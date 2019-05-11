//
//  InviteRequestProcessor.h
//  spotted
//
//  Created by BoHuang on 6/1/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Processor.h"
#import "NotificationModel.h"

@interface InviteRequestProcessor : Processor

-(void)process:(NSDictionary*)payload;
@property (nonatomic, strong) NotificationModel* model;
@end
