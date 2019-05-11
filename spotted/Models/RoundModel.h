//
//  RoundModel.h
//  spotted
//
//  Created by BoHuang on 5/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoundModel : NSObject
@property NSString* mId;
@property NSString* mStatus;
@property NSString* mTask;
@property NSString* mRoundIndex;
@property NSString* mJudgerId;
@property NSString* mRoundWinner;
@property long mStartTime;
@property long mEndTime;
@property NSMutableArray* mAnswers;
-(void) parse:(NSDictionary*) dict;
- (NSString*) getRemainingTimeString;
- (NSString *)timeFormatted:(int)totalSeconds;
@end
