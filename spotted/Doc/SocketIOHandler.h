//
//  SocketIOHandler.h
//  spotted
//
//  Created by BoHuang on 6/30/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>
@import SocketIO;

@interface SocketIOHandler : NSObject
@property (nonatomic, strong) SocketIOClient* socket;

+ (instancetype)shared;
-(void) signIn:(NSString*) userId;
@end
