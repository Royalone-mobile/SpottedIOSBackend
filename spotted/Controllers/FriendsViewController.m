	//
//  FriendsViewController.m
//  spotted
//
//  Created by BoHuang on 4/12/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendTableCellModel.h"
#import "FriendTableViewCell.h"
#import "FriendSectionTableViewCell.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "Global.h"
#import "UserInfo.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Contacts/Contacts.h>
#import "AFNetworking.h"
#import "NetworkParser.h"
#import "FriendProfileViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FriendsViewController ()

@end

@implementation FriendsViewController
@synthesize tblFriends, btnInvite, friends, sections, sectionRows;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self loadFriends];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UserInfo shared].mCurrentScreen = @"FriendsViewController";
}
// #progam mark -helper
- (void)initView{
    
    tblFriends.dataSource = self;
    tblFriends.delegate = self;
    
    [tblFriends registerNib:[UINib nibWithNibName:@"FriendTableViewCell" bundle:nil] forCellReuseIdentifier:@"FriendTableViewCell"];
    [tblFriends registerNib:[UINib nibWithNibName:@"FriendSectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"FriendSectionTableViewCell"];
 
    
}

- (void)loadFriends{
    if(friends == nil) friends = [[NSMutableArray alloc] init];
    if(sections == nil) sections = [[NSMutableArray alloc] init];
    if(sectionRows == nil) sectionRows = [[NSMutableArray alloc] init];
    [sections removeAllObjects];
    [friends removeAllObjects];
    [sectionRows removeAllObjects];
    
    UserModel* account = [[UserInfo shared] mAccount];
    [[NetworkParser shared] onGetFriends:account.mId withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil){
            NSMutableArray* lstFriends = (NSMutableArray*)responseObject;
            if(lstFriends == nil)
                return;
            NSArray * sortedArray = [lstFriends sortedArrayUsingSelector:@selector(compare:)];
            
            NSString* sectionName = @"";
            bool isFirstObj = false;
            int sectionCount = 0;
            for(int i=0; i<sortedArray.count; i++){
                FriendTableCellModel* friend = sortedArray[i];
                isFirstObj = false;
                if(friend.mUser != nil && friend.mUser.mUserName != nil && friend.mUser.mUserName.length > 0 ) {
                    NSString* firstLetter = [friend.mUser.mUserName substringToIndex:1];
                    firstLetter  = [firstLetter uppercaseString];
                    if(![sectionName isEqualToString:firstLetter]){
                        if(![sectionName isEqualToString:@""]) {
                            //not first element
                            [sectionRows addObject:[NSNumber numberWithInteger:sectionCount]];
                        }
                        sectionName = firstLetter;
                        isFirstObj = true;
                        sectionCount = 1;
                    }else {
                        sectionCount ++;
                    }
                    if(isFirstObj){
                        FriendTableCellModel* section = [[FriendTableCellModel alloc] init];
                        section.mType = 1;
                        section.mSectionTitle = sectionName;
                        [sections addObject:section];
                    }
                    [friends addObject:sortedArray[i]];
                    
                }
            }
            //add setionRows count for last section
            if(sectionCount > 0){
                [sectionRows addObject:[NSNumber numberWithInteger:sectionCount]];
            }
            [tblFriends reloadData];
        }
    }];

}



//#progma mark helper
- (void) showAlertImport{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Import Friends" message:@"Add friends to play with from your iPhone or Facebook contacts." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *iphoneContacts = [UIAlertAction actionWithTitle:@"iPhone Contacts" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {[self loadIPhoneContacts];}];
    UIAlertAction *facebookAction = [UIAlertAction actionWithTitle:@"Facebook" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {[self loadFacebookContacts];}];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action) {}];
    
    [alertController addAction:iphoneContacts];
    [alertController addAction:facebookAction];
    [alertController addAction:cancel];
       [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void) serviceGameCreate{
    NSMutableArray* inviteList = [[NSMutableArray alloc]init];
    for(FriendTableCellModel * item in self.friends){
        if(item.mChecked){
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            if(item.mUser.mId != nil)
                [ dict setValue:item.mUser.mId forKey:@"userId"];
            [inviteList addObject: dict];
        }
    }
    if(inviteList.count == 0)
        return;
    UserModel* userModel = [UserInfo shared].mAccount;
    [Global showIndicator:self];
    [[NetworkParser shared] onGameCreate:userModel  withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil){
            self.gameModel = responseObject;

            
            [self inviteSend];
        }else{
            if([VERSION isEqualToString:@"development"]){
                [Global AlertMessage:self Message:responseObject Title:@"Reason"];
            }
        }
        [Global stopIndicator:self];
    }];
}

- (void) inviteSend{
    UserModel* account = [[UserInfo shared] mAccount];
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString:PLAYER_INVITE];
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSURL *URL = [NSURL URLWithString:serverurl];
    
    NSMutableArray* inviteList = [[NSMutableArray alloc]init];
    for(FriendTableCellModel * item in self.friends){
        if(item.mChecked){
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            if(item.mUser.mId != nil)
                [ dict setValue:item.mUser.mId forKey:@"userId"];
            [inviteList addObject: dict];
        }
    }
    if(inviteList.count > 0){
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:inviteList options:nil error:nil];
        NSString* inviteStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [objects addObject:inviteStr];
        [keys addObject:@"inviteList"];
    }
    if(self.gameModel != nil){
        [objects addObject:self.gameModel.mId];
        [keys addObject:@"gameId"];
    }
    if(account.mId != nil) {
        [objects addObject: account.mId];
        [keys addObject:@"userId"];
    }
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [Global showIndicator:self];
    [manager POST:URL.absoluteString parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
         [Global stopIndicator:self];
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Invitations Sent" message:@"You can start the game once two or more players ACCEPT your invite." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dashboard = [UIAlertAction actionWithTitle:@"Go To Dashboard" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
            [self gotoDashboard];
            
        }];
        
        [alertController addAction:dashboard];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [Global stopIndicator:self];
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
                //[[UserInfo shared] setLogined:false];
                
            }
        }
        
        
        
    }];

    
}
- (IBAction)backAction:(id)sender {
    [self gotoDashboard];

}

- (IBAction)inviteAction:(id)sender {

    [self serviceGameCreate];
        
}
- (void) loadIPhoneContacts {
    if(_lstContacts == nil){
        _lstContacts = [[NSMutableArray alloc] init];
    }
    [_lstContacts removeAllObjects];
    
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            //keys with fetching properties
            NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactEmailAddressesKey];
            CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
            NSError *error;
            BOOL success = [store enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact * __nonnull contact, BOOL * __nonnull stop) {
                if (error) {
                    NSLog(@"error fetching contacts %@", error);
                } else {
                    // copy data to my custom Contact class.
                    UserModel *newContact = [[UserModel alloc] init];
                    newContact.mFirstName =  contact.givenName;
                    newContact.mLastName =  contact.familyName;
                    if(contact.phoneNumbers){
                    NSArray <CNLabeledValue<CNPhoneNumber *> *> *phoneNumbers = contact.phoneNumbers;
                    
                    if([phoneNumbers count] >0){
                        CNLabeledValue<CNPhoneNumber *> *firstPhone = [phoneNumbers firstObject];
                        CNPhoneNumber *number = firstPhone.value;

                        newContact.mPhoneNumber = number.stringValue;
                    }}
                    if(contact.emailAddresses){
                    NSArray <CNLabeledValue<NSString*> *> *emailAddresses = contact.emailAddresses;
                    if([emailAddresses count] >0){
                        CNLabeledValue<NSString*> * firstEmail = [emailAddresses firstObject];
                        newContact.mEmail = firstEmail.value;
                    }
                    }
                    [_lstContacts addObject:newContact];
                }
            }];
        }
    }];
}
- (void) loadFacebookContacts {
    NSString* token = [[UserInfo shared] getFacebookToken];
    if([token isEqualToString:@""])
        return;
    
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"user_friends"]) {
          FBSDKGraphRequest *requestFriends = [[FBSDKGraphRequest alloc]
                                           initWithGraphPath:@"me/friendlists" parameters:nil];
        
        FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];

        [connection addRequest:requestFriends
             completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 //TODO: process like information
                 if (!error) {
                     NSLog(@"%@", result);
                 }
                 
             }];
        [connection start];
    }else{
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        if ([UIApplication.sharedApplication canOpenURL:[NSURL URLWithString:@"fb://"]])
        {
            login.loginBehavior = FBSDKLoginBehaviorSystemAccount;
        }
        [Global showIndicator:self];
        [login logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends", @"read_custom_friendlists"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
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
                    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"read_custom_friendlists"]) {
                        FBSDKGraphRequest *requestFriends = [[FBSDKGraphRequest alloc]
                                                             initWithGraphPath:@"me/friendlists" parameters:nil];
                        
                        FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
                        
                        [connection addRequest:requestFriends
                             completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                 //TODO: process like information
                                 if (!error) {
                                     NSLog(@"%@", result);
                                 }
                                 
                             }];
                        [connection start];
                    }

                    [Global stopIndicator:self];
                }else{
                    [Global stopIndicator:self];
                }
                NSLog(@"Login Cancel");
            }
        }];

    }

}



- (void) gotoDashboard {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) gotoMain {
    [Global switchScreen:self withControllerName:@"MainViewController"];
}

#pragma mark UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self sectionCount] ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self rowCountForSection:section];
}


- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    FriendSectionTableViewCell* header = [tableView dequeueReusableCellWithIdentifier:[self headerReuseIdentifier]];
    header.txtTitle.text = [self sectionHeaderString:section];
    return header;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendTableCellModel * model = [self cellModelForIndexPath:indexPath];
    FriendTableViewCell* cell = [self.tblFriends dequeueReusableCellWithIdentifier:@"FriendTableViewCell" forIndexPath:indexPath];
    cell.txtName.text = model.mUser.mUserName;
    cell.txtOnline.hidden = ![model.mUser.mOnline isEqualToString:@"online"];
    cell.imgCheck.hidden = model.mChecked == false;
    [((UIImageView *)cell.imgProfile) sd_setImageWithURL:[NSURL URLWithString:model.mUser.mPhoto] placeholderImage:[UIImage imageNamed:@"splash_back.png"]];
    
    [cell.btnViewProfile addTarget:self action:@selector(detailAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnViewProfile.tag = [self getIndexFromIndexPath:indexPath] ;
    return cell;

}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self cellHeight];
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section{
    return [self headerHeight];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendTableCellModel * model = [self cellModelForIndexPath:indexPath];
        NSMutableArray* indexArray = [[NSMutableArray alloc]init];
        [indexArray addObject:indexPath];
        model.mChecked = !model.mChecked;
        [self.tblFriends reloadRowsAtIndexPaths:  indexArray          withRowAnimation:UITableViewRowAnimationNone];

    
}

- (void) detailAction:(UIButton*)sender{
    long tag= sender.tag;
    FriendTableCellModel* model = [self cellModelForIndex:tag];
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    FriendProfileViewController* vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"FriendProfileViewController"];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{

}


//MARK: - Helpers

- (long) sectionCount{
    if(self.sections != nil && self.sections.count >0){
        return self.sections.count;
    }
    return 1;
}


- (long) rowCountForSection:(long) section {
    if(self.sectionRows == nil || self.sectionRows.count <= section ){
        return 0;
    }
    /*FriendTableCellModel* sectionModel= [self.sections objectAtIndex:section];
    
    long count = 0;
    for(int i=0; i< self.friends.count; i++){
        FriendTableCellModel* friend = self.friends[i];
        
        NSString* firstLetter = [friend.mUser.mUserName substringToIndex:1];
        firstLetter  = [firstLetter uppercaseString];
        if(![sectionModel.mSectionTitle isEqualToString:firstLetter]){
            count++;
        }
    }*/
    NSNumber* rowCount = [sectionRows objectAtIndex:section];
    
    return [rowCount integerValue];
}

- (NSString*) sectionHeaderString: (long) section {
    if(self.sections != nil && self.sections.count > section) {
        FriendTableCellModel* sectionModel= [self.sections objectAtIndex:section];
        return sectionModel.mSectionTitle;
    }else {
        return @"";
    }

}

- (int) headerHeight{
    return 30;
}

- (int) cellHeight{
    return 70;
}

- (NSString*) cellReuseIdentifier {
    return @"FriendTableViewCell";
}

- (NSString*) headerReuseIdentifier {
    return @"FriendSectionTableViewCell";
}

- (FriendTableCellModel*) cellModelForIndexPath: (NSIndexPath*) indexPath{
    long index = [self getIndexFromIndexPath:indexPath];
    if( self.friends.count > index) {
        return [self.friends objectAtIndex:index];
    }else
        return nil;
}

- (FriendTableCellModel*) cellModelForIndex: (NSInteger) index{
    if( self.friends.count > index) {
        return [self.friends objectAtIndex:index];
    }else
        return nil;
}

- (long) getIndexFromIndexPath:(NSIndexPath*) indexPath {
    long index =0 ;
    for(int i=0; i<indexPath.section; i++) {
        index += [sectionRows[i] integerValue];
    }
    index += indexPath.row;
    return index;
}

@end
