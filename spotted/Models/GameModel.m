//
//  GameModel.m
//  spotted
//
//  Created by BoHuang on 4/12/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "GameModel.h"
#import "GamePlayerModel.h"
#import "AnswerModel.h"
#import "Global.h"
#import "UserInfo.h"
@implementation GameModel

- (id)init
{
    if((self = [super init])) {
        self.mId = @"-1";
        self.mTimeEnd = 0;
        self.mGameName = @"";
        self.mGamePlayers = [[NSMutableArray alloc] init];
        self.mGameCreator = [[UserModel alloc] init];
        self.mGameWinner = [[UserModel alloc] init];
        self.mCurrentRound = [[RoundModel alloc] init];
        self.mGameRounds = [[NSMutableArray alloc] init];
        self.mJudgerId = @"";
        
    }
    return self;
}

- (NSString*) getRemainingTimeString {
    
    long milliseconds = (long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    NSString* timeRemaining= @"";
    long timeRemainMiliseconds = self.mTimeEnd - milliseconds;
    if(timeRemainMiliseconds <= 0){
        timeRemainMiliseconds = 0;
    }
    int totalSeconds = (int)(timeRemainMiliseconds / 1000);
    timeRemaining = [self timeFormatted:totalSeconds];
    
    return timeRemaining;
}

- (NSString*) getGameStatusDescription:(NSString*) userId {
    NSString* description =@"Waiting for Task";
    if([self.mGameCreator.mId isEqualToString:userId]){
        description = @"Game Setup";
    }
    if([self checkIfJudge: userId]){
        description = @"Waiting to judge";
    } else if ([self shouldWriteTask:userId]){
        description = @"Write task";
    }else if ([self shouldWaitAnswers:userId]){
        description = @"Waiting for result";
    }else if (self.mCurrentRound.mTask != nil) {
        description = @"Waiting to answer";
    }
    if([self.mStatus isEqualToString:@"close"]){
        description = @"Game Finished";
    }
    return description;
    
}
- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02dhrs %02d min %02d sec",hours, minutes, seconds];
}

-(bool) checkIfJudge:(NSString*) userId{
    if(![self isJudger:userId]) return false;
    
    if([self.mStatus isEqualToString:@"close"]) return false;
    if(self.mCurrentRound.mTask == nil) return false;
    if([self.mCurrentRound.mTask isEqualToString:@""]) return false;
    
    BOOL roundFinished = YES;
    for(GamePlayerModel* model in self.mGamePlayers) {
        if(![self isJudger:model.mUser.mId] && model.mAnswered == 0) {
            roundFinished = NO;
        }
    }
    
    return roundFinished;
}

-(GamePlayerModel*) getGamePlayerModel:(NSString*) userId {
    GamePlayerModel* myModel;
    for(GamePlayerModel* model in self.mGamePlayers){
        if([model.mUser.mId isEqualToString:userId]){
            myModel = model;
        }
    }
    return myModel;
}

-(NSString*) getGamePlayerState:(NSString*) userId{
    GamePlayerModel* myModel;
    for(GamePlayerModel* model in self.mGamePlayers){
        if([model.mUser.mId isEqualToString:userId]){
            myModel = model;
        }
    }
    if(myModel == nil)
        return @"";
    return myModel.mPlayerState;
}
-(int) getRanking:(NSString*) userId{
    int ranking = 1 ;
    GamePlayerModel* myModel;
    for(GamePlayerModel* model in self.mGamePlayers){
        if([model.mUser.mId isEqualToString:userId]){
            myModel = model;
        }
    }
    if(myModel == nil){
        return 0;
    }
    for(GamePlayerModel* model in self.mGamePlayers){
        if(![model.mUser.mId isEqualToString:userId]){
            if(model.mPoint > myModel.mPoint){
                ranking++;
            }
                
        }
    }
    return ranking;
}

-(bool) isJudger:(NSString *)userId {
    return [self.mCurrentRound.mJudgerId isEqualToString: userId];
}

-(bool) shouldWriteTask:(NSString*) userId {
    if([self isJudger: userId] && self.mCurrentRound.mTask == nil){
        return true;
    }
    return false;
        
}
-(bool) shouldWaitAnswers:(NSString*) userId {
    if([self isJudger: userId] && self.mCurrentRound.mTask != nil){
        return true;
    }
    return false;
    
}

-(bool) checkIfCanWriteTask {
    if(self.mGamePlayers == nil)
        return false;
    if(self.mGamePlayers.count >= MIN_PLAYERS)
    {
        return true;
    }
    return false;
}

-(bool) checkIfSubmitAnswer:(NSString*) userId {
    if(self.mCurrentRound == nil)
        return false;
    for(int i=0; i< self.mCurrentRound.mAnswers.count; i++ ){
        AnswerModel* model = [self.mCurrentRound.mAnswers objectAtIndex:i];
        if([model.mUserId isEqualToString:userId]){
            return true;
        }
    }
    return false;
}


-(bool) checkIfShowPrevious {
    int sawIndex = 0;
    NSString* viewedRoundIndex = [[UserInfo shared] getLastSawRoundIndex:self.mId];
    if(viewedRoundIndex == nil || [viewedRoundIndex isEqualToString:@""]) {
        sawIndex  = 0;
    }else
        sawIndex  =  [viewedRoundIndex intValue];
    if(self.mGameRounds.count <= 1)
        return false;
    
    if([self.mStatus isEqualToString:@"close"]) {
        RoundModel* lastModel =  [self.mGameRounds objectAtIndex:self.mGameRounds.count -1];
        if([lastModel.mRoundIndex intValue]  > sawIndex) {
            return true;
        }
    }
    RoundModel* model =  [self.mGameRounds objectAtIndex:self.mGameRounds.count -2];
    if([model.mRoundIndex intValue] >sawIndex) {
        return true;
    }
    return false;
    
}
-(void) parse:(NSDictionary*) dict{
    
    if (self) {
        if([dict objectForKey:@"_id"] != nil)
        {
            self.mId = (NSString*)[dict objectForKey:@"_id"];
        }
        
        if ([dict objectForKey:@"gameName"] != nil) {
            self.mGameName = (NSString*)[dict objectForKey:@"gameName"];
        }
        if ([dict objectForKey:@"startTime"] != nil) {
            self.mStartTime = (NSString*)[dict objectForKey:@"startTime"];
        }
        if ([dict objectForKey:@"status"] != nil) {
            self.mStatus = (NSString*)[dict objectForKey:@"status"];
        }
        
        if ([dict objectForKey:@"endTime"] != nil) {
            self.mEndTime = (NSString*)[dict objectForKey:@"endTime"];
        }
        if ([dict objectForKey:@"gameCreator"] != nil) {
            NSDictionary* userDict = (NSDictionary*)[dict objectForKey:@"gameCreator"];
            
            [self.mGameCreator parse:userDict];
            
        }
        if ([dict objectForKey:@"currentRound"] != nil) {
            NSDictionary* currentRound = (NSDictionary*)[dict objectForKey:@"currentRound"];
            [self.mCurrentRound  parse:currentRound];
        }
        
        if ([dict objectForKey:@"gameRounds"] != nil) {
            NSDictionary* gameRounds = (NSDictionary*)[dict objectForKey:@"gameRounds"];
            for(NSDictionary* roundData in gameRounds) {
                RoundModel* roundModel = [[RoundModel alloc] init];
                [roundModel parse: roundData];
                [self.mGameRounds addObject:roundModel];
            }
        }

        
        if ([dict objectForKey:@"gameCreator"] != nil) {
            NSDictionary* userDict = (NSDictionary*)[dict objectForKey:@"gameCreator"];
            
            [self.mGameCreator parse:userDict];
            
        }
        if ([dict objectForKey:@"gameWinner"] != nil) {
            NSDictionary* userDict = (NSDictionary*)[dict objectForKey:@"gameWinner"];
            
            [self.mGameWinner parse:userDict];
            
        }
        if ([dict objectForKey:@"gameJudger"] != nil) {
            self.mJudgerId = (NSString*)[dict objectForKey:@"gameJudger"];
            
        }
        if([dict objectForKey:@"gamePlayers"] != nil){
            NSDictionary* userDict = (NSDictionary*)[dict objectForKey:@"gamePlayers"];
            for(NSDictionary* item in userDict)
            {
                GamePlayerModel* newModel = [[GamePlayerModel alloc] init];
                [newModel parse:item];
                [self.mGamePlayers addObject:newModel];
            }
        }
        
        if([dict objectForKey:@"judgerId"] != nil){
            self.mJudgerId = (NSString*)[dict objectForKey:@"judgerId"];
        }
    }
    
}
@end
