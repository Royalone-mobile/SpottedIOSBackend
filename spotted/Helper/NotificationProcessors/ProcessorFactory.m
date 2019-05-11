//
//  ProcessorFactory.m
//  spotted
//
//  Created by BoHuang on 6/1/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "ProcessorFactory.h"
#import "InviteRequestProcessor.h"
#import "AnswerRequestProcessor.h"
#import "JudgeRequestProcessor.h"
#import "UpdateRequestProcessor.h"
#import "WinGameProcessor.h"
#import "FriendRequestProcessor.h"
#import "RoundResultShowRequestProcessor.h"
@implementation ProcessorFactory


-(Processor*) createProcessor:(long) type{
    switch (type) {
        case 100:
            return [[InviteRequestProcessor alloc] init];

        case 200:
            return [[AnswerRequestProcessor alloc] init];

        case 300:
            return [[JudgeRequestProcessor alloc] init];
     
        case 400:
            return [[UpdateRequestProcessor alloc] init];
            
        /*case 500:
            return [[WinGameProcessor alloc] init];
         */
        case 600:
            return [[FriendRequestProcessor alloc] init];
            
        case 700:
            return [[RoundResultShowRequestProcessor alloc] init];
    }
    return nil;
}
@end
