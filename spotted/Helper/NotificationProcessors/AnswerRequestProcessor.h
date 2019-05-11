//
//  AnswerRequestProcessor.h
//  spotted
//
//  Created by BoHuang on 6/6/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Processor.h"
#import "NotificationModel.h"

@interface AnswerRequestProcessor : Processor
-(void)process:(NSDictionary*)payload;
@property (nonatomic, strong) NotificationModel* model;
@end
