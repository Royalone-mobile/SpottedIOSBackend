//
//  WinGameProcessor.m
//  spotted
//
//  Created by BoHuang on 6/27/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "WinGameProcessor.h"
#import "NotificationModel.h"
#import "NetworkParser.h"
#import "UserInfo.h"
#import <UIKit/UIKit.h>

@implementation WinGameProcessor

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
    

    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Ok",@"Ok") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [topWindow makeKeyAndVisible];
    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}
@end
