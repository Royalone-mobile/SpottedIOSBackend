//
//  AddNewFriendsViewController.m
//  spotted
//
//  Created by BoHuang on 7/12/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "AddNewFriendsViewController.h"
#import "FriendProfileViewController.h"
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
#import <SDWebImage/UIImageView+WebCache.h>
@interface AddNewFriendsViewController ()<UITextFieldDelegate>

@end

@implementation AddNewFriendsViewController
@synthesize tblFriends, friends, sections, sectionRows;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
    self.txtSearch.delegate = self;
    // Do any additional setup after loading the view.
    //[self searchFriendsData:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//MARK: - IBActions
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)searchAction:(id)sender {
    NSString* searchText = self.txtSearch.text;
    if(searchText.length != 0)
        [self searchFriendsData:searchText];
    else
        [Global AlertMessage:self Message:@"Search Keyword is required" Title:@"Reason"];

    
}
- (IBAction)inviteAction:(id)sender {
    [self requestSend];
}
//MARK: - Helpers


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    NSString* searchText = self.txtSearch.text;
    if(searchText.length != 0)
        [self searchFriendsData:searchText];
    else
         [Global AlertMessage:self Message:@"Search Keyword is required" Title:@"Reason"];
    return YES;
}

- (void)initView{
    
    tblFriends.dataSource = self;
    tblFriends.delegate = self;
    
    [tblFriends registerNib:[UINib nibWithNibName:@"FriendTableViewCell" bundle:nil] forCellReuseIdentifier:@"FriendTableViewCell"];
    [tblFriends registerNib:[UINib nibWithNibName:@"FriendSectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"FriendSectionTableViewCell"];
    
    
}
- (void) requestSend{
    UserModel* account = [[UserInfo shared] mAccount];
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString:REQUEST_FRIENDS];
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSURL *URL = [NSURL URLWithString:serverurl];
    
    NSMutableArray* userList = [[NSMutableArray alloc]init];
    for(FriendTableCellModel * item in self.friends){
        if(item.mChecked){
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            if(item.mUser.mId != nil)
                [ dict setValue:item.mUser.mId forKey:@"userId"];
            [userList addObject: dict];
        }
    }
    if(userList.count > 0){
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:userList options:nil error:nil];
        NSString* inviteStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [objects addObject:inviteStr];
        [keys addObject:@"userList"];
    }
    if(account.mId != nil){
        [objects addObject:account.mId];
        [keys addObject:@"requesterId"];
    }
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [Global showIndicator:self];
    [manager POST:URL.absoluteString parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [Global stopIndicator:self];
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Friends request sent." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dashboard = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
            
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

- (void) searchFriendsData:(NSString*) key {
    if(friends == nil) friends = [[NSMutableArray alloc] init];
    if(sections == nil) sections = [[NSMutableArray alloc] init];
    if(sectionRows == nil) sectionRows = [[NSMutableArray alloc] init];
    [sections removeAllObjects];
    [friends removeAllObjects];
    [sectionRows removeAllObjects];
    [Global showIndicator:self];

    UserModel* account = [[UserInfo shared] mAccount];
    [[NetworkParser shared] onSearchNonFriends:account.mId withKey:key withCompletionBlock:^(id responseObject, NSString *error) {
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
            
            [Global stopIndicator:self];
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
    FriendTableViewCell* cell = [self.tblFriends dequeueReusableCellWithIdentifier:@"FriendTableViewCell" forIndexPath:indexPath];
    cell.txtName.text = model.mUser.mUserName;
    cell.txtOnline.hidden = ![model.mUser.mOnline isEqualToString:@"online"];
    cell.imgCheck.hidden = model.mChecked == false;
    [((UIImageView *)cell.imgProfile) sd_setImageWithURL:[NSURL URLWithString:model.mUser.mPhoto] placeholderImage:[UIImage imageNamed:@"splash_back.png"]];
    [cell.btnViewProfile addTarget:self action:@selector(detailAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnViewProfile.tag = [self getIndexFromIndexPath: indexPath] ;
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
