//
//  RoundResultShowRequestProcessor.m
//  spotted
//
//  Created by BoHuang on 7/28/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "RoundResultShowRequestProcessor.h"
#import "NotificationModel.h"
#import "NetworkParser.h"
#import "UserInfo.h"
#import <UIKit/UIKit.h>

@implementation RoundResultShowRequestProcessor

-(void)process:(NSDictionary*)payload{
    
    NotificationModel* notificationModel= [[NotificationModel alloc] init];
    [notificationModel parse: payload];
    self.model = notificationModel;
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"UpdateScreen"
     object:nil];
    
    
    if([[UserInfo shared] getLogined] == true)
        [self showNotificationAlert:[notificationModel getNotificationMessage] Title:[notificationModel getNotificationTitle]];

}

- (void) showNotificationAlert:(NSString*)message Title:(NSString*) title {
    
    UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = [UIViewController new];
    topWindow.windowLevel = UIWindowLevelAlert + 1;
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Yes",@"Yes") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // continue your work
        
        // important to hide the window after work completed.
        // this also keeps a reference to the window until the action is invoked.
        NSString* userId =  [UserInfo shared].mAccount.mId;
        NSString* gameId =  [self.model getParam:@"gameId"];
        NSString* roundId =  [self.model getParam:@"roundId"];
        
        [[NetworkParser shared] onGetGame:gameId withCompletionBlock:^(id responseObject, NSString *error) {
            GameModel* gameModel = responseObject;
            [UserInfo shared].mCurrentGameModel = gameModel;
            if(error == nil){
                    [[NetworkParser shared] onGetRound:roundId withCompletionBlock:^(id responseObject2, NSString *error) {
                        if(error == nil) {
                            RoundModel* roundModel = responseObject2;
                            [[NSNotificationCenter defaultCenter]
                             postNotificationName:@"OpenRoundResultShow"
                             object:roundModel];
                            [[UserInfo shared] setViewRoundResult:gameId withRoundIndex:roundModel.mRoundIndex];
                        }
                    }];
            }
            
        }];

        topWindow.hidden = YES;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"No",@"No") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        topWindow.hidden = YES;
        NSString* roundId =  [self.model getParam:@"roundId"];
        NSString* userId =  [UserInfo shared].mAccount.mId;
        NSString* gameId =  [self.model getParam:@"gameId"];
        [[NetworkParser shared] onGetRound:roundId withCompletionBlock:^(id responseObject2, NSString *error) {
            if(error == nil) {
                RoundModel* roundModel = responseObject2;
                [[UserInfo shared] setViewRoundResult:gameId withRoundIndex:roundModel.mRoundIndex];
                
            }
        }];
        /*[[NetworkParser shared] onAcceptNotification:userId withGameId:gameId isAccept:NO withCompletionBlock:^(id responseObject, NSString *error) {
            
        }];
        if(self.model.mId != nil ){
            [[NetworkParser shared] onRemoveNotification:self.model.mId withCompletionBlock:^(id responseObject, NSString *error) {
                
            }];
        }*/
    }]];
    
    [topWindow makeKeyAndVisible];
    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}
@end

