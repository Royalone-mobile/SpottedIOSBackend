//
//  Global.h
//  spotted
//
//  Created by BoHuang on 4/11/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "Global.h"
#import <Contacts/Contacts.h>

NSString* VERSION = @"production";
//NSString* SITE_URL = @"http://192.168.1.109:3000/";
//NSString* SOCKET_URL = @"http://192.168.1.109:3000";
//NSString* UPLOAD_URL = @"http://192.168.1.109:3000/uploads/";
//NSString* SHARE_URL = @"http://192.168.1.109/share";
NSString* SITE_URL = @"http://45.55.207.205:3000/";
NSString* UPLOAD_URL = @"http://45.55.207.205:3000/uploads/";
NSString* SOCKET_URL = @"http://45.55.207.205:3000";
NSString* SHARE_URL = @"http://spottedstudios.com";

NSString* LOGIN = @"api/v1/auth/login";
NSString* LOGOUT = @"api/v1/auth/logout";
NSString* FACEBOOK_LOGIN = @"api/v1/auth/facebook/token";
NSString* GAMES = @"api/v1/games";
NSString* GAME_OVER = @"api/v1/game_over";
NSString* ROUNDS = @"api/v1/rounds";
NSString * PLAYER_INVITE = @"api/v1/player_invite";
NSString * PLAYERS = @"api/v1/players";

NSString * UPDATE_TOKEN = @"api/v1/update_token";
NSString * PLAYER_FRIENDS = @"api/v1/player_friends";

NSString * ACCEPT_INVITE = @"api/v1/player_invite_accept";
NSString * ACCEPT_FRIEND = @"api/v1/player_friend_accept";
NSString * REQUEST_FRIENDS = @"api/v1/player_friend_request";


NSString * MY_GAMES = @"api/v1/my_games";
NSString * GAME_CREATE = @"api/v1/game_create";
NSString * DEFAULT_GAME_NAME = @"%@'s Game";
NSString * REMOVE_PLAYER = @"api/v1/game_remove_player";
NSString * WRITE_TASK = @"api/v1/game_write_task";
NSString * SUBMIT_ANSWER = @"api/v1/submit_answer";
NSString * SUBMIT_JUDGE = @"api/v1/submit_judge";
NSString * FORGOT_PASSWORD = @"api/v1/forgot_password";
NSString * GET_PVP_INFO = @"api/v1/get_pvp_info";
NSString * APP_LINK = @"https://fb.me/1899054740412482";
NSString * APP_IMAGE_LINK = @"https://www.mydomain.com/my_invite_image.jpg";
NSString * SEARCH_NON_FRIENDS = @"api/v1/search_non_friends";
NSString * GET_FRIENDS = @"api/v1/player_friends";
NSString * GET_NOTIFICATIONS = @"api/v1/player_notifications";
NSString * DELETE_NOTIFICATION = @"api/v1/delete_notification";

NSString * fbAppId = @"1899054740412482";
NSString * fbAppSecret = @"cc9138d13ba683cbc788bac3bc2a5042";

//NSString * fbAppId = @"1502010389919165";
//NSString * fbAppSecret = @"9603618ffef323c95f495402baee68fb";
NSString * fbAppAccessToken = @"649819365216295|0703b5e9a481d07db1f6957683505c9b";

NSString * ADD_INVITATIONS = @"api/v1/add_invitations";
NSString * RESOLVE_INVITATIONS = @"api/v1/resolve_invitations";


NSString * HOW_TO_PLAY_URL=@"http://spottedstudios.com/how-to-play.html";
NSString * PRIVACY_POLICY_URL=@"http://spottedstudios.com/privacy-policy.html";
NSString * currentScreen = @"VCSplash";

int MIN_PLAYERS = 3;

@implementation Global

+ (Global *)shared
{
    static dispatch_once_t onceToken;
    static Global *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[Global alloc] init];
    });
    return instance;
}


+(void)showIndicator:(UIViewController*)viewcon{
    UIActivityIndicatorView* view = (UIActivityIndicatorView*)[viewcon.view viewWithTag:1000];
    
    if(view == nil){
        CGFloat width = 60.0;
        CGFloat height = 60.0;
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [indicatorView setColor:[UIColor blackColor]];
        indicatorView.center = viewcon.view.center;
        indicatorView.tag = 1000;
        [viewcon.view addSubview:indicatorView];
        [viewcon.view bringSubviewToFront:indicatorView];
        
        view = indicatorView;
    }
    
    view.hidden = false;
    [view startAnimating];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
}
+(void)stopIndicator:(UIViewController*)viewcon{
    UIActivityIndicatorView* view = (UIActivityIndicatorView*)[viewcon.view viewWithTag:1000];
    if(view != nil){
        view.hidden = YES;
        [view stopAnimating];
        
    }
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

+(void)switchScreen:(UIViewController*)viewcon withControllerName: (NSString*)controllerName{
    currentScreen = controllerName;
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* vc = [mainStoryboard instantiateViewControllerWithIdentifier:controllerName];
    [viewcon.navigationController pushViewController:vc animated:NO];
    
}

+(NSInteger)getAge:(NSDate*)birthday{
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:birthday
                                       toDate:now
                                       options:0];
    NSInteger age = [ageComponents year];
    return age;
}
+(NSString*)getDate:(NSDate*)date withFormat:(NSString*) format{
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:format]; // Date formater
    NSString *dateStr = [dateformate stringFromDate:date]; // Convert date to string
    return dateStr;
}

+(NSString*) getUserFriendlyTime:(long) timeInMiliseconds withTodayString:(NSString*) today withTomorrowString:(NSString*) tomorrow{
    NSString* userFriendlyString = @"";
    NSDate* now = [NSDate date];
    NSDate* date = [[NSDate alloc]initWithTimeIntervalSince1970:timeInMiliseconds];
    
    NSCalendar *greg    = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger currentDay= [greg ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:now];
    
    NSUInteger estimateDay= [greg ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:date];
    if(currentDay == estimateDay){
        userFriendlyString =  [[[userFriendlyString stringByAppendingString:today] stringByAppendingString:@" "] stringByAppendingString:[Global getDate:date withFormat:@"hh:mm"]];
    }else if(currentDay + 1 == estimateDay){
        userFriendlyString =  [[[userFriendlyString stringByAppendingString:tomorrow] stringByAppendingString:@" "] stringByAppendingString:[Global getDate:date withFormat:@"hh:mm"]];
    }else{
        userFriendlyString = [Global getDate:date withFormat:@"EEE d MMM yyyy hh:mm"];
    }
    return userFriendlyString;
    
}

+(void)AlertMessage:(UIViewController*)viewController Message:(NSString*)message Title:(NSString*)title{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle your yes please button action here
                               }];
    
    
    [alert addAction:okButton];
    
    
    [viewController presentViewController:alert animated:YES completion:nil];
}

+(void)ConfirmWithCompletionBlock:(UIViewController*)viewController Message:(NSString*)message Title:(NSString*)title withCompletion:(void(^)(NSString* result))onComplete{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   onComplete(@"Ok");
                                   
                               }];
    
    UIAlertAction* cancelButton = [UIAlertAction
                               actionWithTitle:@"Cancel"
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action) {
                                   //Handle your yes please button action here
                                   onComplete(@"Cancel");
                                   
                               }];
    [alert addAction:okButton];
    [alert addAction:cancelButton];
    
    
    [viewController presentViewController:alert animated:YES completion:nil];
}

+(void)AppDelegateAlertMessage:(NSString*)message Title:(NSString*)title {

}


+ (void) shareApp:(UIViewController*)view withButtonView:(UIView*) button{
    NSString *textToShare = @"Spotted! Awesome photographing game.";
    NSURL *myWebsite = [NSURL URLWithString:SHARE_URL];
    
    NSArray *objectsToShare = @[textToShare, myWebsite];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypePostToFacebook,                                   UIActivityTypePostToTwitter,UIActivityTypePostToWeibo,UIActivityTypeMessage,UIActivityTypeMail];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityVC.popoverPresentationController.sourceView = button;

    }
    [view presentViewController:activityVC animated:YES completion:nil];
}

+(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}



@end
