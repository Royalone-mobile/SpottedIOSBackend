//
//  GameModel.h
//  spotted
//
//  Created by BoHuang on 4/12/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "RoundModel.h"
#import "GamePlayerModel.h"
@interface GameModel : NSObject

@property NSString* mId;
@property NSString* mStatus;
@property NSString* mStartTime;
@property NSString* mEndTime;
@property UserModel* mGameCreator;
@property UserModel* mGameWinner;
@property NSMutableArray* mGamePlayers;
@property NSMutableArray* mGameRounds;
@property RoundModel* mCurrentRound;
@property NSString* mGameName;
@property NSString* mJudgerId;
@property long mTimeEnd;  //miliseconds

-(NSString*) getRemainingTimeString;
-(void) parse:(NSDictionary*) dict;
-(bool) checkIfJudge:(NSString*) userId;
-(bool) checkIfSubmitAnswer:(NSString*) userId;
-(bool) isJudger:(NSString*)userId;
-(bool) checkIfCanWriteTask;
-(NSString*) getGamePlayerState:(NSString*) userId;
-(int) getRanking:(NSString*) userId;
-(GamePlayerModel*) getGamePlayerModel:(NSString*) userId;
-(NSString*) getGameStatusDescription:(NSString*) userId;
-(bool) shouldWaitAnswers:(NSString*) userId;
-(bool) checkIfShowPrevious;
@end
