//
//  JudgeRequestProcessor.m
//  spotted
//
//  Created by BoHuang on 6/6/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "JudgeRequestProcessor.h"
#import "NotificationModel.h"
#import "NetworkParser.h"
#import "UserInfo.h"
#import <UIKit/UIKit.h>

@implementation JudgeRequestProcessor
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
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Ok",@"Ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // continue your work
        
        // important to hide the window after work completed.
        // this also keeps a reference to the window until the action is invoked.
        NSString* gameId =  [self.model getParam:@"gameId"];
        NSString* roundId = [self.model getParam:@"roundId"];
        
        
        [[NetworkParser shared] onGetGame:gameId withCompletionBlock:^(id responseObject, NSString *error) {
            if(error == nil){
                GameModel* gameModel = responseObject;
                [UserInfo shared].mCurrentGameModel = gameModel;
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"OpenJudge"
                 object:gameModel];
            }
            
        }];

        
        topWindow.hidden = YES;
    }]];
    
    [topWindow makeKeyAndVisible];
    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}
@end
