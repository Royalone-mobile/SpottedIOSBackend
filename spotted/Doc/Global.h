#ifndef Global_h
#define Global_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Global : NSObject
+ (Global *)shared;

extern  NSString * VERSION;
extern  NSString * SITE_URL;
extern  NSString * UPLOAD_URL;
extern  NSString * SOCKET_URL;
extern  NSString * SHARE_URL;
extern  NSString * LOGIN;
extern  NSString * LOGOUT;
extern  NSString * FACEBOOK_LOGIN;
extern  NSString * PLAYER_INVITE;
extern  NSString * PLAYERS;
extern  NSString * PLAYER_FRIENDS;
extern  NSString * GAMES;
extern  NSString * GAME_OVER;
extern  NSString * ROUNDS;
extern  NSString * UPDATE_TOKEN;
extern  NSString * ACCEPT_INVITE;
extern  NSString * MY_GAMES;
extern  NSString * DEFAULT_GAME_NAME;
extern  NSString * GAME_CREATE;
extern  NSString * REMOVE_PLAYER;
extern  NSString * WRITE_TASK;
extern  NSString * SUBMIT_ANSWER;
extern  NSString * SUBMIT_JUDGE;
extern  NSString * FORGOT_PASSWORD;
extern  NSString * APP_LINK ;
extern  NSString * APP_IMAGE_LINK ;
extern  NSString * GET_PVP_INFO;
extern  NSString * GET_FRIENDS;
extern  NSString * SEARCH_NON_FRIENDS;
extern  NSString * ACCEPT_FRIEND;
extern  NSString * REQUEST_FRIENDS;
extern  NSString * GET_NOTIFICATIONS;
extern  NSString * DELETE_NOTIFICATION;
extern  NSString * fbAppAccessToken;
extern  NSString * ADD_INVITATIONS;
extern  NSString * RESOLVE_INVITATIONS;
extern NSString * HOW_TO_PLAY_URL;
extern NSString * PRIVACY_POLICY_URL;


extern NSString* currentScreen;

extern  int MIN_PLAYERS;


+(void)showIndicator:(UIViewController*)viewcon;
+(void)stopIndicator:(UIViewController*)viewcon;
+(void)switchScreen:(UIViewController*)viewcon withControllerName: (NSString*)controllerName;
+(NSInteger)getAge:(NSDate*)birthday;
+(NSString*) getUserFriendlyTime:(long) timeInMiliseconds withTodayString:(NSString*) today withTomorrowString:(NSString*) tomorrow;
+(void)AlertMessage:(UIViewController*)viewController Message:(NSString*)message Title:(NSString*)title;
+(BOOL) NSStringIsValidEmail:(NSString *)checkString;
+(void)AppDelegateAlertMessage:(NSString*)message Title:(NSString*)title;
+(void)ConfirmWithCompletionBlock:(UIViewController*)viewController Message:(NSString*)message Title:(NSString*)title withCompletion:(void(^)(NSString* result))onComplete;
+ (void) shareApp:(UIViewController*)view withButtonView:(UIView*) button;
@end

#endif /* Global_h */
