//
//  MainViewController.m
//  spotted
//
//  Created by BoHuang on 4/11/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "MainViewController.h"
#import "Global.h"
#import "GameModel.h"
#import "GameViewController.h"
#import "GameSetupViewController.h"
#import "FriendsViewController.h"
#import "NotificationViewController.h"
#import "ImageShowViewController.h"
#import "UserInfo.h"
#import "NetworkParser.h"
#import <AVFoundation/AVFoundation.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@import GoogleMobileAds;

@interface MainViewController ()<GADBannerViewDelegate>
//@property(nonatomic, strong) GADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
@end

@implementation MainViewController
@synthesize tabDashboard, tabProfile, tabFriends, tabShare, tabNotification, tabHowTo,tabPrivacyPolicy;
@synthesize txtDashboard, txtProfile, txtFriends, txtShare, txtNotification, txtHowTo, txtPrivacyPolicy;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self init];
    //ask camera permission
    [self askPermission];
    
    //connect socketio
    [[SocketIOHandler shared] signIn:[UserInfo shared].mAccount.mId];
    
    //check facebook request
    [self checkFacebookRequest];
    

//    self.bannerView = [[GADBannerView alloc]
//                       initWithAdSize:kGADAdSizeBanner];


    
    
//    self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/6300978111";
    self.bannerView.adUnitID = @"ca-app-pub-7779015445667282/2213293787";
    
//        self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    
//        self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/1458002511";
    self.bannerView.rootViewController = self;
    
//    [self.view addSubview:self.bannerView];


    [self.bannerView loadRequest:[GADRequest request]];
    self.bannerView.delegate = self;

//    self.bannerView.frame = CGRectMake(0, self.view.frame.size.height - self.bannerView.frame.size.height , self.view.frame.size.width, self.bannerView.frame.size.height);
    
//    NSLog(@"Ad size = %f", self.bannerView.frame.size.height);

}
- (void) viewDidAppear:(BOOL)animated {
    if([SocketIOHandler shared].socket.status == SocketIOClientStatusDisconnected)
        [[SocketIOHandler shared] signIn:[UserInfo shared].mAccount.mId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"adViewDidReceiveAd");
    adView.alpha = 0;
    [UIView animateWithDuration:1.0 animations:^{
        adView.alpha = 1;
    }];
}

/// Tells the delegate an ad request failed.
- (void)adView:(GADBannerView *)adView
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Tells the delegate that a full screen view will be presented in response
/// to the user clicking on an ad.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillPresentScreen");
}

/// Tells the delegate that the full screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillDismissScreen");
}

/// Tells the delegate that the full screen view has been dismissed.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewDidDismissScreen");
}

/// Tells the delegate that a user click will open another app (such as
/// the App Store), backgrounding the current app.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    NSLog(@"adViewWillLeaveApplication");
}

// progma mark -helper
- (void) initView{
    tabDashboard.tag = 0;
    tabProfile.tag = 1;
    tabFriends.tag = 2;
    tabNotification.tag = 6;
    tabHowTo.tag = 7;
    tabPrivacyPolicy.tag = 8;
    self.selectedTag = -1;
    [self attendActions];
    [self setContainers:0];
    [self.moreNav setHidden:true];
    
}

- (id) init
{
    self = [super init];
    if (!self) return nil;
    
     [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveOpenGameNotification:)
                                                 name:@"OpenGame"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveOpenDashboardNotification:)
                                                 name:@"OpenDashboard"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveOpenEditProfileNotification:)
                                                 name:@"OpenEditProfile"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveOpenProfileNotification:)
                                                 name:@"OpenProfile"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveOpenJudgeNotification:)
                                                 name:@"OpenJudge"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveOpenResultShowNotification:)
                                                 name:@"OpenRoundResultShow"
                                               object:nil];
    
    return self;
}


- (void) attendActions{
    [tabDashboard addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    [tabProfile addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    [tabFriends addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    [tabShare addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    [tabNotification addTarget:self action:@selector(tabAction:) forControlEvents:
        UIControlEventTouchUpInside];
    [tabHowTo addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    [tabPrivacyPolicy addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
}


// progma mark -actions
- (void) tabAction:(id) obj{
    UIButton* button = (UIButton*) obj;
    long tag = button.tag;
    [self setContainers:tag];
    [self setContainerTexts:tag];
    
}
- (IBAction)backNavAction:(id)sender {
    [self.moreNav setHidden:true];
}
- (IBAction)moreAction:(id)sender {
    NSLog(@"moreAction");
    [self.moreNav setHidden:false];
}
- (IBAction)signoutAction:(id)sender {
    [[UserInfo shared] setLogined:false];
    [Global switchScreen:self withControllerName:@"LoginViewController"];
    [[UserInfo shared] setFacebookToken:@""];
    
}
- (void) receiveOpenGameNotification:(NSNotification *) notification
{                  UserModel* mAccount = [UserInfo shared].mAccount;
    if ([[notification name] isEqualToString:@"OpenGame"])
    {
        GameModel* gameModel = (GameModel*)[notification object];
        if(gameModel != nil){
            if([gameModel checkIfShowPrevious]) {
                if([gameModel.mStatus isEqualToString:@"close"]) {
                    RoundModel* previousRound = [gameModel.mGameRounds objectAtIndex:gameModel.mGameRounds.count-1];
                    
                    [[UserInfo shared] setViewRoundResult:gameModel.mId withRoundIndex:previousRound.mRoundIndex];
                    [Global ConfirmWithCompletionBlock:self Message:@"Judging Complete, View Images?" Title:@"Spotted" withCompletion:^(NSString *result) {
                        if([result isEqualToString:@"Ok"])
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:@"OpenRoundResultShow"
                         object:previousRound];
                    }];
                }else {
                    RoundModel* previousRound = [gameModel.mGameRounds objectAtIndex:gameModel.mGameRounds.count-2];
                
                    [[UserInfo shared] setViewRoundResult:gameModel.mId withRoundIndex:previousRound.mRoundIndex];
                    [Global ConfirmWithCompletionBlock:self Message:@"Judging Complete, View Images?" Title:@"Spotted" withCompletion:^(NSString *result) {
                        if([result isEqualToString:@"Ok"])
                        [[NSNotificationCenter defaultCenter]
                        postNotificationName:@"OpenRoundResultShow"
                        object:previousRound];
                    }];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if([gameModel.mGameCreator.mId isEqualToString: mAccount.mId]){
                GameSetupViewController* controller =(GameSetupViewController*) self.gameSetupViewController;
                controller.gameModel = gameModel;
                
                [self setContainers:5];
                
            }else{
                
                GameViewController* controller =(GameViewController*) self.gameViewController;
                controller.gameModel = gameModel;
                
                [self setContainers:3];
            }
            
        });


      
        
    }
}
- (void) receiveOpenDashboardNotification:(NSNotification *) notification
{
    
    if ([[notification name] isEqualToString:@"OpenDashboard"])
    {
        [self setContainers:0];
        
    }
}

- (void) receiveOpenEditProfileNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"OpenEditProfile"])
    {
        [self setContainers:4];
        
    }
}
- (void) receiveOpenProfileNotification:(NSNotification *) notification
{
    
    if ([[notification name] isEqualToString:@"OpenProfile"])
    {
        [self setContainers:1];
        
    }
}
- (void) receiveOpenJudgeNotification:(NSNotification *) notification
{
    
    if ([[notification name] isEqualToString:@"OpenJudge"]){
        if(![currentScreen isEqualToString:@"JudgeImageViewController"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                [Global switchScreen:self withControllerName:@"JudgeImageViewController"];
                UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                ImageShowViewController* vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"JudgeImageViewController"];
                [self.navigationController pushViewController:vc animated:NO];
            });
        }
  
    }
}

- (void) receiveOpenResultShowNotification:(NSNotification *) notification
{
    
    if ([[notification name] isEqualToString:@"OpenRoundResultShow"]){
          RoundModel *roundModel = (RoundModel *)notification.object;
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ImageShowViewController* vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"ImageShowViewController"];
        vc.mRoundModel = roundModel;
        [self.navigationController pushViewController:vc animated:NO];
        
    }
}

// progma mark -container view
- (void) setContainers:(long) index{
    if(self.selectedTag == index)
        return;
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    if(self.dashboardViewController == nil)
        self.dashboardViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    
    if(self.profileViewController == nil)
        self.profileViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    
    if(self.friendsTabViewController == nil){
        FriendsViewController* vc =  [mainStoryboard instantiateViewControllerWithIdentifier:@"FriendsTabViewController"];
        self.friendsTabViewController = vc;
        
    }
    if(self.notificationViewController == nil) {
        NotificationViewController* vc =  [mainStoryboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
        self.notificationViewController = vc;
    }
    
    if(self.gameViewController == nil)
        self.gameViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"GameViewController"];
    
    if(self.profileEditViewController == nil)
        self.profileEditViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ProfileEditViewController"];
    
    if(self.gameSetupViewController == nil)
         self.gameSetupViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"GameSetupViewController"];

    
    if(self.howtoViewController == nil)
        self.howtoViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"HTPTabViewController"];
    
    if(self.privacyPolicyViewController == nil)
        self.privacyPolicyViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"TPTabViewController"];
    
    if(self.currentViewController == nil){
        if(index == 0){
            self.currentViewController = self.dashboardViewController;
            [self addViewController:self.dashboardViewController];
            
        }
        if(index == 1){
            self.currentViewController = self.profileViewController;
            [self addViewController:self.profileViewController];
            
        }
        if(index == 2){
            self.currentViewController = self.friendsTabViewController;
            [self addViewController:self.friendsTabViewController];
            
        }
        if(index == 3){
            self.currentViewController = self.gameViewController;
            [self addViewController:self.gameViewController];
            
        }
        if(index == 4){
            self.currentViewController = self.profileEditViewController   ;
            [self addViewController:self.profileEditViewController];
        }
        if(index == 5){
            self.currentViewController = self.gameSetupViewController;
            [self addViewController:self.gameSetupViewController];
        }
        if(index == 6){
            self.currentViewController = self.notificationViewController;
            [self addViewController:self.notificationViewController];
        }
        if(index == 7){
            self.currentViewController = self.howtoViewController;
            [self addViewController:self.howtoViewController];
        }
        if(index == 8){
            self.currentViewController = self.privacyPolicyViewController;
            [self addViewController:self.privacyPolicyViewController];
        }

    
    }else{
        if(index == 0){
            [self cycleFromViewController:self.currentViewController toViewController:self.dashboardViewController];
            self.currentViewController = self.dashboardViewController;
            
            
        }
        if(index == 1){
            [self cycleFromViewController:self.currentViewController toViewController:self.profileViewController];
            self.currentViewController = self.profileViewController;
            
            
        }
        if(index == 2){
            [self cycleFromViewController:self.currentViewController toViewController:self.friendsTabViewController];
            self.currentViewController = self.friendsTabViewController;
            
            
        }
        if(index == 3){
            [self cycleFromViewController:self.currentViewController toViewController:self.gameViewController];
            self.currentViewController = self.gameViewController;
            
            
        }
        if(index == 4){
            [self cycleFromViewController:self.currentViewController toViewController:self.profileEditViewController];
            self.currentViewController = self.profileEditViewController;
        }
        if(index == 5){
            [self cycleFromViewController:self.currentViewController toViewController:self.gameSetupViewController];
            self.currentViewController = self.gameSetupViewController;
        }
        if(index == 6){
            [self cycleFromViewController:self.currentViewController toViewController:self.notificationViewController];
            self.currentViewController = self.notificationViewController;
        }
        if(index == 7){
            [self cycleFromViewController:self.currentViewController toViewController:self.howtoViewController];
            self.currentViewController = self.howtoViewController;
        }
        if(index == 8){
            [self cycleFromViewController:self.currentViewController toViewController:self.privacyPolicyViewController];
            self.currentViewController = self.privacyPolicyViewController;
        }

    }
    self.selectedTag = index;

}

- (void) setContainerTexts:(long) tag {
    UIColor* white = [UIColor whiteColor];
    UIColor* black = [UIColor blackColor];
    [txtDashboard setTextColor:(tag == 0 ? black :white)];
    [txtProfile setTextColor:(tag == 1 ? black :white)];
    [txtFriends setTextColor:(tag == 2 ? black :white)];
    [txtNotification setTextColor:(tag == 6 ? black :white)];
    [txtHowTo setTextColor:(tag == 7 ? black :white)];
    [txtPrivacyPolicy setTextColor:(tag == 8 ? black :white)];

    //[txtShare setTextColor:(tag == 3 ? black :white)];
    
    
}

- (void)cycleFromViewController:(UIViewController*) oldViewController
               toViewController:(UIViewController*) newViewController {
    [oldViewController willMoveToParentViewController:nil];
    [self addChildViewController:newViewController];
    [self addSubview:newViewController.view toView:self.containerView];
    
    [oldViewController.view removeFromSuperview];
    [oldViewController removeFromParentViewController];
    [newViewController didMoveToParentViewController:self];
    
   /* newViewController.view.alpha = 0;
     [newViewController.view layoutIfNeeded];
     
     [UIView animateWithDuration:0.5
     animations:^{
     newViewController.view.alpha = 1;
     oldViewController.view.alpha = 0;
     }
     completion:^(BOOL finished) {
     [oldViewController.view removeFromSuperview];
     [oldViewController removeFromParentViewController];
     [newViewController didMoveToParentViewController:self];
     }];*/
}

- (void)addSubview:(UIView *)subView toView:(UIView*)parentView {
    subView.frame = parentView.bounds;
    [parentView addSubview:subView];
    
    NSDictionary * views = @{@"subView" : subView,};
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|"
                                                                   options:0
                                                                   metrics:0
                                                                     views:views];
    [parentView addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subView]|"
                                                          options:0
                                                          metrics:0
                                                            views:views];
    [parentView addConstraints:constraints];
    
}

- (void)addViewController:(UIViewController*)newViewController {
    
    //[self addSubview:newViewController.view toView:self.containerView];
    newViewController.view.frame = self.containerView.bounds;
    [self.containerView addSubview:newViewController.view];
    [self addChildViewController:newViewController];
    [newViewController didMoveToParentViewController:self];
    
    return;
}

//progma mark camera permission

-(void) askPermission{
    NSLog(@"here");
    AVAuthorizationStatus cameraPermissionStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (cameraPermissionStatus) {
        case AVAuthorizationStatusAuthorized:
            NSLog(@"Already Authorized");
            break;
        case AVAuthorizationStatusDenied:
        {
            NSLog(@"Denied");
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sorry :(" message:@"But coould you please grant permission for camera within device settings" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:true completion:nil];
            break;
        }
        case AVAuthorizationStatusRestricted:
            NSLog(@"Restricted");
            break;
        default:
            
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                // Will get here on both iOS 7 & 8 even though camera permissions weren't required
                // until iOS 8. So for iOS 7 permission will always be granted.
                if (granted) {
                    // Permission has been granted. Use dispatch_async for any UI updating
                    // code because this block may be executed in a thread.
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                    });
                } else {
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"WHY?" message:@"Camera it is the main feature of our application" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:action];
                    [self presentViewController:alert animated:true completion:nil];
                }
            }];
            
            break;
            
    }
}


//Check facebook requests
-(void) checkFacebookRequest {
    if([UserInfo shared].mAccount == nil)
        return;
    if([UserInfo shared].mAccount.mFacebookId == nil)
        return;
    if([UserInfo shared].mAccount.mId == nil)
        return;
    [[NetworkParser shared] onResolveInvitaions: [UserInfo shared].mAccount.mId withFacebookId:[UserInfo shared].mAccount.mFacebookId withCompletionBlock:^(id responseObject, NSString *error) {
        
    }];
    
}
@end
