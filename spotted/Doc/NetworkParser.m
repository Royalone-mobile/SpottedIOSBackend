//
//  NetworkParser.m
//  spotted
//
//  Created by BoHuang on 6/1/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "NetworkParser.h"
#import "GameModel.h"
#import "PVPInfoModel.h"
#import "UserInfo.h"
#import "Global.h"
#import "FriendTableCellModel.h"
#import "NotificationModel.h"

@implementation NetworkParser

+ (instancetype)shared
{
    static NetworkParser *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NetworkParser alloc] init];
        
    });
    
    return sharedInstance;
}

- (void)onGetPVPInfos :(NSString*)userId withFriendId:(NSString*) friendId withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString:GET_PVP_INFO];
    
    NSURL *URL = [NSURL URLWithString:serverurl];
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    [objects addObject:userId];
    [keys addObject:@"userId"];
    [objects addObject:friendId];
    [keys addObject:@"friendId"];
    
    
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:URL.absoluteString parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        PVPInfoModel* model = [[PVPInfoModel alloc] init];
        NSDictionary *data = responseObject;
        [model parse:data];
        
        completionBlock(model, nil);
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
                completionBlock(nil, reason);
            }
        }else {
            completionBlock(nil, errResponse);
        }
    }];

}
- (void)onAcceptNotification:(NSString*)userId withGameId:(NSString*) gameId isAccept:(BOOL)isAccept withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString:ACCEPT_INVITE];
    
    NSURL *URL = [NSURL URLWithString:serverurl];
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSNumber* _isAccept =[NSNumber numberWithBool:isAccept];
    
    [objects addObject:userId];
    [keys addObject:@"userId"];
    [objects addObject:gameId];
    [keys addObject:@"gameId"];
    [objects addObject:_isAccept];
    [keys addObject:@"isAccept"];
    
    
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:URL.absoluteString parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completionBlock(responseObject, nil);
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
                completionBlock(nil, reason);
            }
        }else {
            completionBlock(nil, errResponse);
        }
    }];
    
}


- (void)onAcceptFriendRequest:(NSString*)userId withRequesterId:(NSString*) requesterId isAccept:(BOOL)isAccept withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString:ACCEPT_FRIEND];
    
    NSURL *URL = [NSURL URLWithString:serverurl];
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSNumber* _isAccept =[NSNumber numberWithBool:isAccept];
    
    [objects addObject:userId];
    [keys addObject:@"userId"];
    [objects addObject:requesterId];
    [keys addObject:@"requesterId"];
    [objects addObject:_isAccept];
    [keys addObject:@"isAccept"];

    
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:URL.absoluteString parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completionBlock(responseObject, nil);
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
                completionBlock(nil, reason);
            }
        }else {
            completionBlock(nil, errResponse);
        }
    }];

}

- (void)onGetMyGames:(NSString*)userId withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString:MY_GAMES];
    
    NSURL *URL = [NSURL URLWithString:serverurl];
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    [objects addObject:userId];
    [keys addObject:@"userId"];
    
    
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:URL.absoluteString parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSMutableArray * gamesArr = [[NSMutableArray alloc] init];
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *games = responseObject;
        for(NSDictionary* game in games){
            GameModel *newModel = [[GameModel alloc] init];
            [newModel parse:game];
            [gamesArr addObject:newModel];
        }
        
        completionBlock(gamesArr, nil);
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
                completionBlock(nil, reason);
            }
        }else {
            completionBlock(nil, errResponse);
        }
    }];
}

-(void)onGetRound:(NSString*)roundId withCompletionBlock:
(NetworkCompletionBlock)completionBlock {
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString:ROUNDS];
    serverurl = [[serverurl stringByAppendingString:@"/"] stringByAppendingString:roundId];
    NSURL *URL = [NSURL URLWithString:serverurl];
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *round = responseObject;
        RoundModel *newModel = [[RoundModel alloc] init];
        [newModel parse:round];
        
        completionBlock(newModel, nil);
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
                completionBlock(nil, reason);
            }
        }else {
            completionBlock(nil, errResponse);
        }
    }];
}

- (void)onGetGame:(NSString*)gameId withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString:GAMES];
    serverurl = [[serverurl stringByAppendingString:@"/"] stringByAppendingString:gameId];
    NSURL *URL = [NSURL URLWithString:serverurl];

    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {

        NSLog(@"JSON: %@", responseObject);
        NSDictionary *game = responseObject;
        GameModel *newModel = [[GameModel alloc] init];
        [newModel parse:game];
        
        completionBlock(newModel, nil);
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
                completionBlock(nil, reason);
            }
        }else {
            completionBlock(nil, errResponse);
        }
    }];
}

- (void)onGameCreate:(UserModel *)userModel withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString:GAME_CREATE];
    
    NSString* gameName = [NSString stringWithFormat:DEFAULT_GAME_NAME, userModel.mUserName];
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    NSString* start = [NSString stringWithFormat: @"%l", (long)startTime];
    
    NSTimeInterval endTime = startTime + 24*60*60*60;
    NSString* end = [NSString stringWithFormat: @"%l", (long)endTime];
    
    NSString* status = @"open";
    
    NSURL *URL = [NSURL URLWithString:serverurl];
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [objects addObject:userModel.mId];
    [keys addObject:@"gameCreator"];
    
    [objects addObject:gameName];
    [keys addObject:@"gameName"];
    
    [objects addObject:start];
    [keys addObject:@"startTime"];
    
    [objects addObject:end];
    [keys addObject:@"endTime"];
    
    [objects addObject:status];
    [keys addObject:@"status"];
    
    
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:URL.absoluteString parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSMutableArray * gamesArr = [[NSMutableArray alloc] init];
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *game = responseObject;
            GameModel *newModel = [[GameModel alloc] init];
            [newModel parse:game];
        
        completionBlock(newModel, nil);
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
                completionBlock(nil, reason);
            }
        }else {
            completionBlock(nil, errResponse);
        }
    }];
   
}

- (void)onRemovePlayer:(NSString*)userId withGameId:(NSString*) gameId withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString: REMOVE_PLAYER];
    
    NSURL *URL = [NSURL URLWithString:serverurl];
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];

    [objects addObject:userId];
    [keys addObject:@"userId"];
    [objects addObject:gameId];
    [keys addObject:@"gameId"];

    
    
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:URL.absoluteString parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completionBlock(responseObject, nil);
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
                completionBlock(nil, reason);
            }
        }else {
            completionBlock(nil, errResponse);
        }
    }];
}

- (void)onRenameGameName:(NSString*)gameName withGameId:(NSString*)gameId withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString: GAMES];
    serverurl = [[serverurl stringByAppendingString:@"/"] stringByAppendingString:gameId];
    NSURL *URL = [NSURL URLWithString:serverurl];
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [objects addObject:gameName];
    [keys addObject:@"gameName"];
  
    
    
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager PUT:URL.absoluteString parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completionBlock(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
                completionBlock(nil, reason);
            }
        }else {
            completionBlock(nil, errResponse);
        }
    }];
  }

- (void)onDeleteGame:(NSString*)gameId  withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString: GAMES];
    serverurl = [[serverurl stringByAppendingString:@"/"] stringByAppendingString:gameId];
    NSURL *URL = [NSURL URLWithString:serverurl];
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];

    
    
    
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager DELETE:URL.absoluteString parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completionBlock(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
                completionBlock(nil, reason);
            }
        }else {
            completionBlock(nil, errResponse);
        }
    }];

}



- (void)onWriteTask:(NSString*)gameId withUserId:(NSString*)userId withTask:(NSString*)task withCompletionBlock:(NetworkCompletionBlock) completionBlock{
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString: WRITE_TASK];
    
    NSURL *URL = [NSURL URLWithString:serverurl];
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    [objects addObject:userId];
    [keys addObject:@"userId"];
    [objects addObject:gameId];
    [keys addObject:@"gameId"];
    
    [objects addObject:task];
    [keys addObject:@"task"];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:URL.absoluteString parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completionBlock(responseObject, nil);
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
                completionBlock(reason, errResponse);
            }
        }else {
            
            completionBlock(errResponse, errResponse);
        }
    }];

}

- (void)onGameOver:(NSString*)gameId  withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString:GAME_OVER];
    serverurl = [[serverurl stringByAppendingString:@"/"] stringByAppendingString:gameId];
    NSURL *URL = [NSURL URLWithString:serverurl];
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    
    
    
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:URL.absoluteString parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completionBlock(responseObject, nil);
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
                completionBlock(nil, reason);
            }
        }else {
            completionBlock(nil, errResponse);
        }
    }];

    
}

- (void)onSubmitJudge:(NSString*)userId withGameId:(NSString*)gameId withRoundId:(NSString*)roundId withAnswerId:(NSString*)answerId withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString:SUBMIT_JUDGE];
    
    NSURL *URL = [NSURL URLWithString:serverurl];
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    [objects addObject:userId];
    [keys addObject:@"userId"];
    [objects addObject:gameId];
    [keys addObject:@"gameId"];
    [objects addObject:roundId];
    [keys addObject:@"roundId"];
    [objects addObject:answerId];
    [keys addObject:@"answerId"];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:URL.absoluteString parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completionBlock(responseObject, nil);
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
                completionBlock(nil, reason);
            }
        }else {
            completionBlock(nil, errResponse);
        }
    }];
    

}

- (void)onUpdateProfileWithNoImage:(NSString *)userId withUsername:(NSString *)username withEmail:(NSString *)email withPassword:(NSString *)password withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"email"];
    [objects addObject:email];
    if(password != nil && ![password isEqualToString:@""]){
        [keys addObject:@"password"];
        [objects addObject:password];
    }
    [keys addObject:@"firstName"];
    [objects addObject:username];
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString: PLAYERS];
    serverurl = [[serverurl stringByAppendingString:@"/"] stringByAppendingString:userId];
    NSURL *URL = [NSURL URLWithString:serverurl];
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager PUT:URL.absoluteString parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary* user = (NSDictionary*)responseObject;
        UserModel* account = [UserInfo shared].mAccount;
        [account parse:user];
        completionBlock(account, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
                completionBlock(nil, reason);
            }else
                completionBlock(nil, errResponse);
        }else {
            
            completionBlock(errResponse, errResponse);
        }

    }];
    

}

- (void)onUpdateProfile:(NSString*) userId withImage:(UIImage*)image withUsername:(NSString*) username  withEmail :(NSString*) email withPassword:(NSString*) password withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"email"];
    [objects addObject:email];
    if(password != nil && ![password isEqualToString:@""]){
        [keys addObject:@"password"];
        [objects addObject:password];
    }
    [keys addObject:@"firstName"];
    [objects addObject:username];
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString: PLAYERS];
    serverurl = [[serverurl stringByAppendingString:@"/"] stringByAppendingString:userId];
    NSURL *URL = [NSURL URLWithString:serverurl];
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"PUT" URLString:URL.absoluteString parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSString* filename = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        filename = [filename stringByAppendingString:@".jpeg"];
        
        NSData *imageData = UIImageJPEGRepresentation(image,0.7);
        [formData appendPartWithFileData:imageData name:@"image" fileName:filename mimeType:@"multipart/form-data;boundary=*****"];
        
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                          //[progressView setProgress:uploadProgress.fractionCompleted];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
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
                                  completionBlock(nil, reason);
                              }else
                                   completionBlock(nil, errResponse);
                          }else {
                              
                              completionBlock(nil, errResponse);
                          }
                          
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                          
                          NSDictionary* user = (NSDictionary*)responseObject;
                          UserModel* account = [UserInfo shared].mAccount;
                          [account parse:user];
                          completionBlock(account, nil);
                      }
                      
                  }];
    
    [uploadTask resume];

}


- (void)onSubmitAnswer:(UIImage*)answerImage  withUserId:(NSString*)userId withGameId:(NSString*) gameId withRoundId:(NSString*)roundId withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"userId"];
    [objects addObject:userId];
    [keys addObject:@"gameId"];
    [objects addObject:gameId];
    [keys addObject:@"roundId"];
    [objects addObject:roundId];
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString: SUBMIT_ANSWER];
    NSURL *URL = [NSURL URLWithString:serverurl];
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL.absoluteString parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSString* filename = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        filename = [filename stringByAppendingString:@".jpeg"];
        
        NSData *imageData = UIImageJPEGRepresentation(answerImage,0.7);
        [formData appendPartWithFileData:imageData name:@"image" fileName:filename mimeType:@"multipart/form-data;boundary=*****"];
        
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                          //[progressView setProgress:uploadProgress.fractionCompleted];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
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
                                  completionBlock(nil, reason);
                              }
                          }else {
                              
                              completionBlock(nil, errResponse);
                          }
                 
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                          completionBlock(responseObject,nil);
                      }
              
                  }];
    
    [uploadTask resume];
}

- (void) onForgotPassword:(NSString *)email withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString:FORGOT_PASSWORD];
    
    NSURL *URL = [NSURL URLWithString:serverurl];
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    [objects addObject:email];
    [keys addObject:@"email"];

    	
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:URL.absoluteString parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completionBlock(responseObject, nil);
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
                completionBlock(nil, reason);
            }
        }else {
            completionBlock(nil, errResponse);
        }
    }];
    
}


- (void)onUpdateAPNSToken:(NSString *)token withUserId:(NSString*) userId withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString:UPDATE_TOKEN];
    
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    serverurl = [[serverurl stringByAppendingString:@"/"] stringByAppendingString:userId];
    [objects addObject:token];
    [keys addObject:@"APNSToken"];
    NSURL *URL = [NSURL URLWithString:serverurl];
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:URL.absoluteString parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        completionBlock(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
                completionBlock(nil, reason);
            }
        }else {
            completionBlock(nil, errResponse);
        }
        
    }];
    
    
}

- (void)onGetUserInfo:(NSString*)userId withCompletionBlock: (NetworkCompletionBlock)completionBlock {
    UserModel* account = [[UserInfo shared] mAccount];
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString:PLAYERS];
    
    
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    serverurl = [[serverurl stringByAppendingString:@"/"] stringByAppendingString:userId];

    NSURL *URL = [NSURL URLWithString:serverurl];
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary* dict = (NSDictionary*)responseObject;
        [account parse:dict];
        account.mOnline = @"true";
        [[UserInfo shared] setLogined:true];
        completionBlock(account, nil);
    }  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
                completionBlock(nil, reason);
            }
        }else {
            completionBlock(nil, errResponse);
        }
        
    }];
    
}

- (void)onSearchNonFriends:(NSString*)userId withKey:(NSString*) key withCompletionBlock:
(NetworkCompletionBlock)completionBlock{
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString:SEARCH_NON_FRIENDS];
    
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    serverurl = [[serverurl stringByAppendingString:@"/"] stringByAppendingString:userId];
    
    NSURL *URL = [NSURL URLWithString:serverurl];
    
    [objects addObject:key];
    [keys addObject:@"key"];
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:URL.absoluteString parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary* dict = (NSDictionary*)responseObject;
        NSMutableArray* lstFriends = [[NSMutableArray alloc] init];
        for(NSDictionary* item in dict){
            FriendTableCellModel *newModel = [[FriendTableCellModel alloc] init];
            [newModel.mUser parse:item];
            newModel.mChecked =false;
            newModel.mType = 0;
            if(![newModel.mUser.mId isEqualToString: userId]){
                [lstFriends addObject:newModel];
            }
        }
        completionBlock(lstFriends, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
                completionBlock(nil, reason);
            }
        }else {
            completionBlock(nil, errResponse);
        }
        
    }];


}

- (void)onRemoveNotification : (NSString*) notificationId withCompletionBlock:
(NetworkCompletionBlock)completionBlock{
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString:DELETE_NOTIFICATION];
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    serverurl = [[serverurl stringByAppendingString:@"/"] stringByAppendingString:notificationId];
    NSURL *URL = [NSURL URLWithString:serverurl];
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:URL.absoluteString parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completionBlock(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
                completionBlock(nil, reason);
            }
        }else {
            completionBlock(nil, errResponse);
        }
        
    }];

}

-(void) onAddInvitaions:(NSString*) userId withInviteList:(NSArray*) inviteList withCompletionBlock:
(NetworkCompletionBlock)completionBlock {
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString:ADD_INVITATIONS];
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    if(inviteList.count > 0){
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:inviteList options:nil error:nil];
        NSString* inviteStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [objects addObject:inviteStr];
        [keys addObject:@"inviteList"];
    }
    if(userId != nil){
        [objects addObject:userId];
        [keys addObject:@"userId"];
    }
    NSURL *URL = [NSURL URLWithString:serverurl];
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:URL.absoluteString parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completionBlock(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
                completionBlock(nil, reason);
            }
        }else {
            completionBlock(nil, errResponse);
        }
        
    }];

}

-(void) onResolveInvitaions:(NSString*) userId withFacebookId: (NSString*) facebookId  withCompletionBlock:
(NetworkCompletionBlock)completionBlock {
    if(userId == nil || facebookId == nil)
        completionBlock(nil, @"input is nil");
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString:RESOLVE_INVITATIONS];
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSURL *URL = [NSURL URLWithString:serverurl];
    [objects addObject:userId];
    [keys addObject:@"userId"];
    
    [objects addObject:facebookId];
    [keys addObject:@"facebookId"];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:URL.absoluteString parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completionBlock(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
                completionBlock(nil, reason);
            }
        }else {
            completionBlock(nil, errResponse);
        }
        
    }];
    
}
- (void)onGetNotifications:(NSString*)userId withCompletionBlock:
(NetworkCompletionBlock)completionBlock {
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString:GET_NOTIFICATIONS];
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    serverurl = [[serverurl stringByAppendingString:@"/"] stringByAppendingString:userId];
    
    NSURL *URL = [NSURL URLWithString:serverurl];
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary* dict = (NSDictionary*)responseObject;
        NSMutableArray* lstNotifications = [[NSMutableArray alloc] init];
        for(NSDictionary* item in dict){
            NotificationModel *newModel = [[NotificationModel alloc] init];
            [newModel parse:item];
            [lstNotifications addObject:newModel];
        }
        completionBlock(lstNotifications, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
                completionBlock(nil, reason);
            }
        }else {
            completionBlock(nil, errResponse);
        }
        
    }];
    

}

- (void)onGetFriends:(NSString*)userId withCompletionBlock:
(NetworkCompletionBlock)completionBlock{
    NSString *serverurl = SITE_URL;
    serverurl = [serverurl stringByAppendingString:GET_FRIENDS];
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    serverurl = [[serverurl stringByAppendingString:@"/"] stringByAppendingString:userId];
    
    NSURL *URL = [NSURL URLWithString:serverurl];
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:URL.absoluteString parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary* dict = (NSDictionary*)responseObject;
        NSMutableArray* lstFriends = [[NSMutableArray alloc] init];
        for(NSDictionary* item in dict){
            FriendTableCellModel *newModel = [[FriendTableCellModel alloc] init];
            if( [item isKindOfClass:[NSDictionary class]]){
                [newModel.mUser parse:item];
                newModel.mChecked =false;
                newModel.mType = 0;
                if(![newModel.mUser.mId isEqualToString: userId]){
                    [lstFriends addObject:newModel];
                }
            }
        }
        completionBlock(lstFriends, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
                completionBlock(nil, reason);
            }
        }else {
            completionBlock(nil, errResponse);
        }
        
    }];
    
    
}
@end
