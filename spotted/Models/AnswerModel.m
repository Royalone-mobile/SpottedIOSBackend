//
//  AnswerModel.m
//  spotted
//
//  Created by BoHuang on 4/13/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "AnswerModel.h"
#import "Global.h"
#import "UserInfo.h"
#import "GameModel.h"

@implementation AnswerModel
-(void) parse:(NSDictionary*) dict{
    
    if (self) {
        if([dict objectForKey:@"_id"] != nil)
        {
            self.mId = (NSString*)[dict objectForKey:@"_id"];
        }
        if([dict objectForKey:@"answerCreator"] != nil)
        {
            self.mUserId = (NSString*)[dict objectForKey:@"answerCreator"];
        }
        
        if([dict objectForKey:@"imageUrl"] != nil)
        {
            self.mImageUrl = [UPLOAD_URL stringByAppendingString: (NSString*)[dict objectForKey:@"imageUrl"]];
        }
    }
    
}

-(UserModel*) getAnswerOwner{
    GameModel* gameModel = [UserInfo shared].mCurrentGameModel;
    if(gameModel == nil){
        return nil;
    }else {
        for(GamePlayerModel* model in gameModel.mGamePlayers) {
            UserModel* user = model.mUser;
            if(user != nil && [user.mId isEqualToString:self.mUserId] ){
                return user;
            }
        }
    }
    return nil;
}
@end
