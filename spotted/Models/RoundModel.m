//
//  RoundModel.m
//  spotted
//
//  Created by BoHuang on 5/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "RoundModel.h"
#import "AnswerModel.h"

@implementation RoundModel

- (id)init
{
    if((self = [super init])) {
        self.mId = @"-1";
        self.mAnswers = [[NSMutableArray alloc] init];
    }
    return self;
}
-(void) parse:(NSDictionary*) dict{
    
    if (self) {
        if([dict objectForKey:@"_id"] != nil)
        {
            self.mId = (NSString*)[dict objectForKey:@"_id"];
        }
        if([dict objectForKey:@"task"] != nil)
        {
            self.mTask = (NSString*)[dict objectForKey:@"task"];
        }
        
        if([dict objectForKey:@"roundIndex"] != nil)
        {
            long roundIndex = [[dict objectForKey:@"roundIndex"] longValue];
            self.mRoundIndex = [[NSNumber numberWithInteger:roundIndex] stringValue];
        }
        
        if([dict objectForKey:@"judger"] != nil)
        {
            self.mJudgerId = (NSString*)[dict objectForKey:@"judger"];
        }
        if ([dict objectForKey:@"startTime"] != nil) {
            self.mStartTime = [[dict objectForKey:@"startTime"] longValue];
        }
        
        if ([dict objectForKey:@"status"] != nil) {
            self.mStatus = (NSString*)[dict objectForKey:@"status"];
        }
        
        if ([dict objectForKey:@"endTime"] != nil) {
            self.mEndTime = [[dict objectForKey:@"endTime"] longValue];
        }
        
        if([dict objectForKey:@"answers"] != nil){
            [self.mAnswers removeAllObjects];
            NSDictionary* userDict = (NSDictionary*)[dict objectForKey:@"answers"];
            for(NSDictionary* item in userDict)
            {
                AnswerModel* newModel = [[AnswerModel alloc] init];
                [newModel parse:item];
                [self.mAnswers addObject:newModel];
            }
        }
        
        if ([dict objectForKey:@"roundWinner"] != nil) {
            self.mRoundWinner = (NSString*)[dict objectForKey:@"roundWinner"];
        }
      }
    
}

- (NSString*) getRemainingTimeString {
    long mTimeEnd = self.mEndTime;
   
    
    long milliseconds = (long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    NSString* timeRemaining= @"";
    long timeRemainMiliseconds = mTimeEnd - milliseconds;
    if(timeRemainMiliseconds <= 0){
        timeRemainMiliseconds = 0;
    }
    if( mTimeEnd == 0 ){
        timeRemainMiliseconds = 86400000;
    }
    
    int totalSeconds = (int)(timeRemainMiliseconds / 1000);
    timeRemaining = [self timeFormatted:totalSeconds];
    
    return timeRemaining;
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}
@end
