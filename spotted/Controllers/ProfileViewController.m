//
//  ProfileViewController.m
//  spotted
//
//  Created by BoHuang on 4/12/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "ProfileViewController.h"
#import "FriendsViewController.h"
#import "BadgeModel.h"
#import "BadgeCollectionViewCell.h"
#import "UserInfo.h"
#import "NetworkParser.h"
#import "Global.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Global.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize imgProfile, txtName, btnEdit, btnConnectFacebook, collectionBadges, txtGamePlayed, txtGameWon, txtPoints, badgeItems;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self loadData];
    _spacing = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// load data

- (void)loadData {

    [self getUserInfo];

    
}

- (void) getUserInfo {
    
    
    UserModel* account = [[UserInfo shared] mAccount];
    if([[UserInfo shared] getLogined] && account.mId != nil && ![account.mId isEqualToString:@""]){
        [Global showIndicator:self];
        [[NetworkParser shared] onGetUserInfo:account.mId withCompletionBlock:^(id responseObject, NSString *error) {
            if(error == nil){
                badgeItems = [UserInfo shared].mAccount.mBadges;
                [collectionBadges reloadData];
            }
            [Global stopIndicator:self];
        }];
    }else{
        return;
    }
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UserModel* account =[UserInfo shared].mAccount;
    txtName.text = account.mUserName;
    txtPoints.text =  [NSString stringWithFormat:@"%ld",account.mPoints] ;
    txtGameWon.text = [NSString stringWithFormat:@"%ld",account.mWins] ;
    txtGamePlayed.text = [NSString stringWithFormat:@"%ld",account.mPlays] ;
    
    [self.imgProfile sd_setImageWithURL:[NSURL URLWithString:account.mPhoto ]
                    placeholderImage:[UIImage imageNamed:@"splash_back.png"]];
    [self loadData];
    [UserInfo shared].mCurrentScreenProfile = @"ProfileViewController";

}

// progma mark -helper
- (void) initView{
    collectionBadges.dataSource = self;
    collectionBadges.delegate = self;

 
    if([UserInfo shared].getFacebookToken != nil && ![[UserInfo shared].getFacebookToken isEqualToString:@""]){
        [btnConnectFacebook setHidden:YES];
    }
    
    self.sectionInsects = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [collectionBadges registerNib:[UINib nibWithNibName:@"BadgeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BadgeCollectionViewCell"];
    [self attendActions];
}

- (void) sendProfileEditNotification{
    
    // All instances of TestClass will be notified
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"OpenEditProfile"
     object:nil];
    
}


- (void) attendActions{
    [btnEdit addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
 
    
}

// progma mark -actions
- (void) editAction:(id) obj{
    [self sendProfileEditNotification];
}

//progma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return badgeItems.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BadgeModel* model = [self.badgeItems objectAtIndex:indexPath.row];
    NSString *identifier = @"BadgeCollectionViewCell";
    
    BadgeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.txtBadgeName setText:model.mName];
    [((UIImageView *)cell.badgeImage) sd_setImageWithURL:[NSURL URLWithString:model.mImageUrl] placeholderImage:[UIImage imageNamed:@"splash_back.png"]];
    return cell;
}
//progma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(90, 128);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    NSInteger cellCount = [collectionView.dataSource collectionView:collectionView numberOfItemsInSection:section];
    if( cellCount >1 )
    {
        CGFloat cellWidth = ((UICollectionViewFlowLayout*)collectionViewLayout).itemSize.width+((UICollectionViewFlowLayout*)collectionViewLayout).minimumInteritemSpacing;
        CGFloat totalCellWidth = cellWidth*cellCount + _spacing*(cellCount-1);
        CGFloat contentWidth = collectionView.frame.size.width-collectionView.contentInset.left-collectionView.contentInset.right;
        if( totalCellWidth<contentWidth )
        {
            CGFloat padding = (contentWidth - totalCellWidth) / 2.0;
            return UIEdgeInsetsMake(0, padding, 0, padding);
        }
    }else if(cellCount == 1) {
        //CGFloat cellWidth = ((UICollectionViewFlowLayout*)collectionViewLayout).itemSize.width;
        CGFloat cellWidth= 90;
        CGFloat totalCellWidth = cellWidth*cellCount + _spacing*(cellCount-1);
        CGFloat contentWidth = collectionView.frame.size.width-collectionView.contentInset.left-collectionView.contentInset.right;
        if( totalCellWidth<contentWidth )
        {
            CGFloat padding = (contentWidth - totalCellWidth) / 2.0;
            return UIEdgeInsetsMake(0, padding, 0, padding);
        }
    }
    return UIEdgeInsetsZero;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return self.sectionInsects.left;
}



//progma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}

- (IBAction)addFriendsAction:(id)sender {
     /*   UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    FriendsViewController* vc = (FriendsViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"FriendsViewController"];

    vc.screenCase = @"ADD_FRIENDS";
    [self.navigationController pushViewController:vc animated:nil];*/
    
    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    content.appLinkURL = [NSURL URLWithString:APP_LINK];
    //optionally set previewImageURL
    content.appInvitePreviewImageURL = [NSURL URLWithString:APP_IMAGE_LINK];
    
    [FBSDKAppInviteDialog showFromViewController:self
                                     withContent:content
                                        delegate:self];
}

- (IBAction)actionFacebookConnect:(id)sender {
    [self fblogin];
}

//MARK - FBSDKAppInviteDialogDelegate

- (void) appInviteDialog:	(FBSDKAppInviteDialog *)appInviteDialog
didCompleteWithResults:	(NSDictionary *)results {
      NSLog(@"%@",results);
}

- (void) appInviteDialog:	(FBSDKAppInviteDialog *)appInviteDialog
didFailWithError:	(NSError *)error{
      NSLog(@"%@",error);
}


-(void)fblogin{
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    if ([UIApplication.sharedApplication canOpenURL:[NSURL URLWithString:@"fb://"]])
    {
        login.loginBehavior = FBSDKLoginBehaviorSystemAccount;
    }
    [Global showIndicator:self];
    [login logInWithReadPermissions:@[@"public_profile", @"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error)
        {
            [Global stopIndicator:self];
            NSLog(@"Unexpected login error: %@", error);
            NSString *alertMessage = error.userInfo[FBSDKErrorLocalizedDescriptionKey] ?: @"There was a problem logging in. Please try again later.";
            NSString *alertTitle = error.userInfo[FBSDKErrorLocalizedTitleKey] ?: @"Oops";
            [[[UIAlertView alloc] initWithTitle:alertTitle
                                        message:alertMessage
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            
        }
        else
        {
            if(result.token)   // This means if There is current access token.
            {
                [[UserInfo shared] setFacebookToken:result.token.tokenString];
                
                //[self facebookLogin:result.token.tokenString];
                [Global stopIndicator:self];
            }else{
                [Global stopIndicator:self];
            }
            NSLog(@"Login Cancel");
        }
    }];
}

- (void) facebookLogin :(NSString*) facebookToken{
    //TODO implement Api to login
    UserModel* account = [[UserInfo shared] mAccount];
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString:FACEBOOK_LOGIN];
    
    NSURL *URL = [NSURL URLWithString:serverurl];
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    [objects addObject:facebookToken];
    [keys addObject:@"access_token"];
    
    if(account.mToken != nil && ![account.mToken isEqualToString:@""]){
        [objects addObject:account.mToken];
        [keys addObject:@"APNSToken"];
    }
    
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [Global showIndicator:self];
    [manager GET:URL.absoluteString parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary* dict = (NSDictionary*)responseObject;
        NSDictionary* user = (NSDictionary*)[dict objectForKey:@"user"];
        [account parse:user];
        account.mOnline = @"true";
        [[UserInfo shared] setLogined:true];
        [[UserInfo shared] setUserId:account.mId];
        [self updateToken];
        [Global stopIndicator:self];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        
        NSError *jsonError;
        NSData *objectData = [errResponse dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&jsonError];
        NSLog(@"%@", errResponse);
        if(jsonError == nil){
            if([json valueForKey:@"reason"]){
                NSString* reason = [json valueForKey:@"reason"];
                [Global AlertMessage:self Message:reason Title:@"Reason"];
            }
        }
        [Global stopIndicator:self];
        
    }];
    
    
}
- (void) updateToken {
    UserModel* account = [[UserInfo shared] mAccount];
    if(account.mId != nil
       && ![account.mId isEqualToString:@""]
       && account.mToken != nil
       && ![account.mToken isEqualToString: @""]){
        
        [Global showIndicator:self];
        [[NetworkParser shared] onUpdateAPNSToken:account.mToken withUserId:account.mId withCompletionBlock:^(id responseObject, NSString *error) {
            [Global stopIndicator:self];
      
        }];
    }
}

@end
