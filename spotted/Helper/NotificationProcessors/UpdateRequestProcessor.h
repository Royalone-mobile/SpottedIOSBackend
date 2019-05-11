//
//  UpdateRequestProcessor.h
//  spotted
//
//  Created by BoHuang on 6/9/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotificationModel.h"
#import "Processor.h"

@interface UpdateRequestProcessor : Processor
@property (nonatomic, strong) NotificationModel* model;
@end
