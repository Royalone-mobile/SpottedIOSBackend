//
//  AppDelegate.m
//  spotted
//
//  Created by BoHuang on 4/7/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "AppDelegate.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "UserInfo.h"
#import "NotificationModel.h"
#import "Global.h"
#import "NotificationProcessor.h"
@import GoogleMobileAds;
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    //push setting
    UIUserNotificationSettings* settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound                                                    categories:nil];

    [[UIApplication sharedApplication]registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication]registerForRemoteNotifications];
    
    [Fabric with:@[[Crashlytics class]]];
    [GADMobileAds configureWithApplicationID:@"ca-app-pub-7779015445667282~9212024391"];
    return YES;
}
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    //if ( application.applicationState == UIApplicationStateActive ){

        [[NotificationProcessor shared] process:userInfo];
        
    //}
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString* newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"My token is: %@", newToken);
    
    UserInfo *env = [UserInfo shared];
    env.mAccount.mToken = newToken;
    
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options{
    //fb set up
    return [[FBSDKApplicationDelegate sharedInstance] application:app                                                                                                                                                     openURL:url                                                                                                                                           sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]                                                                                                                                                  annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



 @end
