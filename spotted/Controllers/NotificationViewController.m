//
//  NotificationViewController.m
//  spotted
//
//  Created by BoHuang on 7/13/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationModel.h"
#import "NotificationGameInviteCell.h"
#import "NotificationFriendRequestCell.h"
#import "FriendSectionTableViewCell.h"

#import "Global.h"
#import "UserInfo.h"
#import "AFNetworking.h"
#import "NetworkParser.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface NotificationViewController ()

@end

@implementation NotificationViewController
@synthesize tblNotifications, notifications, sections, sectionRows;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//MARK: - Helpers

- (void)initView{
    
    tblNotifications.dataSource = self;
    tblNotifications.delegate = self;
    
    [tblNotifications registerNib:[UINib nibWithNibName:@"NotificationGameInviteCell" bundle:nil] forCellReuseIdentifier:@"NotificationGameInviteCell"];
    [tblNotifications registerNib:[UINib nibWithNibName:@"NotificationFriendRequestCell" bundle:nil] forCellReuseIdentifier:@"NotificationFriendRequestCell"];
    [tblNotifications registerNib:[UINib nibWithNibName:@"FriendSectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"FriendSectionTableViewCell"];
    
    
}


- (void)loadNotifications{
    if(notifications == nil) notifications = [[NSMutableArray alloc] init];
    if(sections == nil) sections = [[NSMutableArray alloc] init];
    if(sectionRows == nil) sectionRows = [[NSMutableArray alloc] init];
    [sections removeAllObjects];
    [notifications removeAllObjects];
    [sectionRows removeAllObjects];
    
    UserModel* account = [[UserInfo shared] mAccount];
    [[NetworkParser shared] onGetNotifications:account.mId withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil){
            NSMutableArray* lstNotifications = (NSMutableArray*)responseObject;
            if(lstNotifications == nil)
                return;
            NSArray * sortedArray = [lstNotifications sortedArrayUsingSelector:@selector(compare:)];
            
            
            NSString* sectionName = @"";
            bool isFirstObj = false;
            int sectionCount = 0;
            for(int i=0; i<sortedArray.count; i++){
                NotificationModel* notification = sortedArray[i];
                isFirstObj = false;
                if(notification.mId != nil) {
                    NSString* sectionStr = [self sectionStringFromType:notification.mType];
                    if(![sectionName isEqualToString:sectionStr]){
                        if(![sectionName isEqualToString:@""]) {
                            //not first element
                            [sectionRows addObject:[NSNumber numberWithInteger:sectionCount]];
                        }
                        sectionName = sectionStr;
                        isFirstObj = true;
                        sectionCount = 1;
                    }else {
                        sectionCount ++;
                    }
                    if(isFirstObj){

                        [sections addObject:sectionName];
                    }
                    
                    [notifications addObject:sortedArray[i]];
                    
                }
            }
            //add setionRows count for last section
            if(sectionCount > 0){
                [sectionRows addObject:[NSNumber numberWithInteger:sectionCount]];
            }
            [tblNotifications reloadData];
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
    NotificationModel * model = [self cellModelForIndexPath:indexPath];
    if(model.mType == 100 ){
        NotificationGameInviteCell* cell = [self.tblNotifications dequeueReusableCellWithIdentifier:@"NotificationGameInviteCell" forIndexPath:indexPath];
        cell.labRequesterName.text = [model getParam:@"requesterName"];
        cell.btnAccept.tag = indexPath.item;
        cell.btnDecline.tag = indexPath.item;
        [cell.btnAccept addTarget:self action:@selector(acceptAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnDecline addTarget:self action:@selector(declineAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else {
        NotificationFriendRequestCell* cell = [self.tblNotifications dequeueReusableCellWithIdentifier:@"NotificationFriendRequestCell" forIndexPath:indexPath];
        
        cell.labRequesterName.text = [model getParam:@"firstName"];
        NSString*  imageUrl = [model getParam:@"imageUrl"];
        if(imageUrl != nil) {
        NSString* fullUrl = [UPLOAD_URL stringByAppendingString:imageUrl];
        [((UIImageView *)cell.imgRequester) sd_setImageWithURL:[NSURL URLWithString:fullUrl] placeholderImage:[UIImage imageNamed:@"splash_back.png"]];
        }
        cell.btnAccept.tag = indexPath.item;
        cell.btnDecline.tag = indexPath.item;
        [cell.btnAccept addTarget:self action:@selector(acceptAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnDecline addTarget:self action:@selector(declineAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    
    
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

- (void) declineAction:(UIButton*)sender{
    long tag= sender.tag;
    NotificationModel* model = [self cellModelForIndex:tag];
    [Global ConfirmWithCompletionBlock:self Message:@"Do you want to decline?" Title:@"Alert" withCompletion:^(NSString *result) {
        if(model.mType == 100 ){
            NSString* userId =  [UserInfo shared].mAccount.mId;
            NSString* gameId =  [model getParam:@"gameId"];
            
            [[NetworkParser shared] onAcceptNotification:userId withGameId:gameId isAccept:NO withCompletionBlock:^(id responseObject, NSString *error) {
                
            }];
            if(model.mId != nil ){
                [[NetworkParser shared] onRemoveNotification:model.mId withCompletionBlock:^(id responseObject, NSString *error) {
 
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [notifications removeObjectAtIndex:tag];
                    NSNumber* rowCount = [sectionRows objectAtIndex:0];
                    
                    long rowcount = [rowCount integerValue];
                    rowcount -= 1;
                    if(rowcount < 0) rowcount = 0;
                    [sectionRows setObject:[NSNumber numberWithInteger:rowcount] atIndexedSubscript:0];
                    [tblNotifications reloadData];
                });
            }
        }else if (model.mType == 600) {
            NSString* userId =  [UserInfo shared].mAccount.mId;
            NSString* requesterId =  [model getParam:@"requesterId"];
            
            [[NetworkParser shared] onAcceptFriendRequest:userId withRequesterId:requesterId isAccept:YES withCompletionBlock:^(id responseObject, NSString *error) {
                
            }];
            
            if(model.mId != nil ){
                [[NetworkParser shared] onRemoveNotification:model.mId withCompletionBlock:^(id responseObject, NSString *error) {
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [notifications removeObjectAtIndex:tag];
                    long index =sections.count -1;
                    if(index <0)
                        index = 0;
                    NSNumber* rowCount = [sectionRows objectAtIndex:index];
                    
                    long rowcount = [rowCount integerValue];
                    rowcount -= 1;
                    if(rowcount < 0) rowcount = 0;
                    [sectionRows setObject:[NSNumber numberWithInteger:rowcount] atIndexedSubscript:index];
                    [tblNotifications reloadData];
                });

            }
        }

          }];
    
  
}

- (void) acceptAction:(UIButton*)sender {
    long tag = sender.tag;
      NotificationModel* model = [self cellModelForIndex:tag];
    
    [Global ConfirmWithCompletionBlock:self Message:@"Do you want to accept?" Title:@"Alert" withCompletion:^(NSString *result) {
        if(model.mType == 100 ){
            NSString* userId =  [UserInfo shared].mAccount.mId;
            NSString* gameId =  [model getParam:@"gameId"];
            
            [[NetworkParser shared] onAcceptNotification:userId withGameId:gameId isAccept:YES withCompletionBlock:^(id responseObject, NSString *error) {
                
            }];
            if(model.mId != nil ){
                [[NetworkParser shared] onRemoveNotification:model.mId withCompletionBlock:^(id responseObject, NSString *error) {
                    
                }];
            }
            [notifications removeObjectAtIndex:tag];
            
            NSNumber* rowCount = [sectionRows objectAtIndex:0];
            
            long rowcount = [rowCount integerValue];
            rowcount -= 1;
            if(rowcount < 0) rowcount = 0;
            [sectionRows setObject:[NSNumber numberWithInteger:rowcount] atIndexedSubscript:0];
            [tblNotifications reloadData];
        }else if (model.mType == 600) {
            NSString* userId =  [UserInfo shared].mAccount.mId;
            NSString* requesterId =  [model getParam:@"requesterId"];
            
            [[NetworkParser shared] onAcceptFriendRequest:userId withRequesterId:requesterId isAccept:YES withCompletionBlock:^(id responseObject, NSString *error) {
                
            }];
            
            if(model.mId != nil ){
                [[NetworkParser shared] onRemoveNotification:model.mId withCompletionBlock:^(id responseObject, NSString *error) {

                }];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [notifications removeObjectAtIndex:tag];
                long index =sections.count -1;
                if(index <0)
                    index = 0;
                NSNumber* rowCount = [sectionRows objectAtIndex:index];
                
                long rowcount = [rowCount integerValue];
                rowcount -= 1;
                if(rowcount < 0) rowcount = 0;
                [sectionRows setObject:[NSNumber numberWithInteger:rowcount] atIndexedSubscript:index];
                [tblNotifications reloadData];
            });
        }

    }];
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
        return [self.sections objectAtIndex:section];
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

- (NSString*) sectionStringFromType :(long) type {
    if(type == 100) {
        return @"Game Invites";
    }else if(type == 600) {
        return @"Friend Request";
    }else
        return @"Other";
}

- (NotificationModel*) cellModelForIndexPath: (NSIndexPath*) indexPath{
    if( self.notifications.count > indexPath.item) {
        return [self.notifications objectAtIndex:indexPath.item];
    }else
        return nil;
}
- (NotificationModel*) cellModelForIndex: (NSInteger) index{
    if( self.notifications.count > index) {
        return [self.notifications objectAtIndex:index];
    }else
        return nil;
}

@end
