//
//  FriendsTabViewController.m
//  spotted
//
//  Created by BoHuang on 7/12/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "FriendsTabViewController.h"
#import "FriendProfileViewController.h"
#import "FriendTableCellModel.h"
#import "FriendTabTableViewCell.h"
#import "FriendSectionTableViewCell.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "Global.h"
#import "UserInfo.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Contacts/Contacts.h>
#import "AFNetworking.h"
#import "NetworkParser.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface FriendsTabViewController ()

@end

@implementation FriendsTabViewController
@synthesize tblFriends, friends, sections, sectionRows;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadFriends];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//MARK: - IBActions
- (IBAction)menuAction:(id)sender {
    [self showMenuAlert];
}

//MARK: - Actions

- (void) addNewFriends {
    [Global switchScreen:self withControllerName:@"AddNewFriendsViewController"];
}

- (void) addNewFriendsFromFacebook {
 /*   FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    content.appLinkURL = [NSURL URLWithString:APP_LINK];
    //optionally set previewImageURL
    content.appInvitePreviewImageURL = [NSURL URLWithString:APP_IMAGE_LINK];
    
    [FBSDKAppInviteDialog showFromViewController:self
                                     withContent:content
                                        delegate:self];*/
    FBSDKGameRequestContent *gameRequestContent = [[FBSDKGameRequestContent alloc] init];

    // Look at FBSDKGameRequestContent for futher optional properties
    
    
    gameRequestContent.data = @"Awesome camera game: Spotted!";
    gameRequestContent.message = @"Awesome camera game: Spotted!";
    gameRequestContent.title = @"Spotted Game";
    
    gameRequestContent.actionType = FBSDKGameRequestActionTypeNone;
    // Assuming self implements <FBSDKGameRequestDialogDelegate>
//    [FBSDKGameRequestDialog showWithContent:gameRequestContent delegate:self];
    
    if (![FBSDKAccessToken currentAccessToken]) {
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        
        [login logInWithReadPermissions:@[@"public_profile",@"email", @"user_photos"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            
            if (error) {
                
                // Process error
                
            } else if (result.isCancelled) {
                
                // Handle cancellations
                
            } else if(result.token){
                
                FBSDKGameRequestDialog* dialog = [[FBSDKGameRequestDialog alloc] init];
                dialog.frictionlessRequestsEnabled = YES;
                dialog.content = gameRequestContent;
                dialog.delegate = self;
                
                // Assuming self implements <FBSDKGameRequestDialogDelegate>
                [dialog show];
            }
            
        }];
        
    }else {
        FBSDKGameRequestDialog* dialog = [[FBSDKGameRequestDialog alloc] init];
        dialog.frictionlessRequestsEnabled = YES;
        dialog.content = gameRequestContent;
        dialog.delegate = self;
        
        // Assuming self implements <FBSDKGameRequestDialogDelegate>
        [dialog show];
    }
    
    
    
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

//MARK - FBSDKGameRequestDialogDelegate

- (void) gameRequestDialog:(FBSDKGameRequestDialog *)gameRequestDialog didCompleteWithResults:(NSDictionary *)results {
    NSLog(@"Facebook request result %@",results);
    NSArray *fbIds = (NSArray*)[results objectForKey:@"to"];

    if(fbIds.count > 0 ){
        [[NetworkParser shared] onAddInvitaions:[UserInfo shared].mAccount.mId withInviteList:fbIds withCompletionBlock:^(id responseObject, NSString *error) {
            
        }];
    }
    
}

- (void) gameRequestDialog:(FBSDKGameRequestDialog *)gameRequestDialog didFailWithError:(NSError *)error {
    NSLog(@"%@",error);
}


- (void)gameRequestDialogDidCancel:(FBSDKGameRequestDialog *)gameRequestDialog {
    NSLog(@"gameRequestDialogDidCancel");
}

//MARK: - Helpers

- (void)initView{
    
    tblFriends.dataSource = self;
    tblFriends.delegate = self;
    
    [tblFriends registerNib:[UINib nibWithNibName:@"FriendTabTableViewCell" bundle:nil] forCellReuseIdentifier:@"FriendTabTableViewCell"];
    [tblFriends registerNib:[UINib nibWithNibName:@"FriendSectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"FriendSectionTableViewCell"];
    
    
}

- (void) showMenuAlert{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Add Friends" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *newFriends = [UIAlertAction actionWithTitle:@"Add new friends" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {[self addNewFriends];}];
    UIAlertAction *newFriendsFromFacebook = [UIAlertAction actionWithTitle:@"Add new friends from facebook" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {[self addNewFriendsFromFacebook];}];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action) {}];
    
    [alertController addAction:newFriends];
    [alertController addAction:newFriendsFromFacebook];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)loadFriends{
    if(friends == nil) friends = [[NSMutableArray alloc] init];
    if(sections == nil) sections = [[NSMutableArray alloc] init];
    if(sectionRows == nil) sectionRows = [[NSMutableArray alloc] init];
    [sections removeAllObjects];
    [friends removeAllObjects];
    [sectionRows removeAllObjects];
    
    UserModel* account = [[UserInfo shared] mAccount];
    [Global showIndicator:self];
    [[NetworkParser shared] onGetFriends:account.mId withCompletionBlock:^(id responseObject, NSString *error) {
        [Global stopIndicator:self];
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
    FriendTabTableViewCell* cell = [self.tblFriends dequeueReusableCellWithIdentifier:@"FriendTabTableViewCell" forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.txtName.text = model.mUser.mUserName;
    cell.txtOnline.hidden = ![model.mUser.mOnline isEqualToString:@"online"];
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
   
    
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void) detailAction:(UIButton*)sender{
    long tag= sender.tag;
    
    FriendTableCellModel* model = [self cellModelForIndex:tag];
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    FriendProfileViewController* vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"FriendProfileViewController"];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
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
    return @"FriendTabTableViewCell";
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
