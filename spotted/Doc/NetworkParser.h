//
//  NetworkParser.h
//  spotted
//
//  Created by BoHuang on 6/1/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "GameModel.h"

typedef void (^NetworkCompletionBlock)(id responseObject, NSString* error);
@interface NetworkParser : NSObject
+ (instancetype)shared;
- (void)onAcceptNotification:(NSString*)userId withGameId:(NSString*) gameId isAccept:(BOOL)isAccept withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)onGetMyGames:(NSString*)userId withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)onGameCreate:(UserModel*)userModel withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)onRemovePlayer:(NSString*)userId withGameId:(NSString*) gameId withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)onRenameGameName:(NSString*)gameName withGameId:(NSString*)gameId  withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)onDeleteGame:(NSString*)gameId  withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)onGameOver:(NSString*)gameId  withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)onWriteTask:(NSString*)gameId withUserId:(NSString*)userId withTask:(NSString*)task withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)onGetGame:(NSString*)gameId  withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)onSubmitAnswer:(UIImage*)answerImage  withUserId:(NSString*)userId withGameId:(NSString*) gameId withRoundId:(NSString*)roundId withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)onSubmitJudge:(NSString*)userId withGameId:(NSString*)gameId withRoundId:(NSString*)roundId withAnswerId:(NSString*)answerId withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)onForgotPassword:(NSString*)email withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)onUpdateProfile:(NSString*) userId withImage:(UIImage*)image withUsername:(NSString*) username  withEmail :(NSString*) email withPassword:(NSString*) password withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)onUpdateProfileWithNoImage:(NSString*) userId withUsername:(NSString*) username  withEmail :(NSString*) email withPassword:(NSString*) password withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)onUpdateAPNSToken:(NSString *)token withUserId:(NSString*) userId withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)onGetUserInfo:(NSString*)userId withCompletionBlock: (NetworkCompletionBlock)completionBlock;
- (void)onGetPVPInfos :(NSString*)userId withFriendId:(NSString*) friendId withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)onSearchNonFriends:(NSString*)userId withKey:(NSString*) key withCompletionBlock:
(NetworkCompletionBlock)completionBlock;

- (void)onGetFriends:(NSString*)userId withCompletionBlock:
(NetworkCompletionBlock)completionBlock;

- (void)onAcceptFriendRequest:(NSString*)userId withRequesterId:(NSString*) gameId isAccept:(BOOL)isAccept withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)onRemoveNotification : (NSString*) notificationId withCompletionBlock:
(NetworkCompletionBlock)completionBlock;

- (void)onGetNotifications:(NSString*)userId withCompletionBlock:
(NetworkCompletionBlock)completionBlock;

-(void) onAddInvitaions:(NSString*) userId withInviteList:(NSArray*) inviteList withCompletionBlock:
(NetworkCompletionBlock)completionBlock;

-(void) onResolveInvitaions:(NSString*) userId withFacebookId: (NSString*) facebookId  withCompletionBlock:
(NetworkCompletionBlock)completionBlock;

-(void)onGetRound:(NSString*)roundId withCompletionBlock:
(NetworkCompletionBlock)completionBlock;
@end
