//
//  WinGameProcessor.h
//  spotted
//
//  Created by BoHuang on 6/27/17.
//  Copyright © 2017 ITLove. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "NotificationModel.h"
#import "Processor.h"

@interface WinGameProcessor : Processor
@property (nonatomic, strong) NotificationModel* model;
@end
