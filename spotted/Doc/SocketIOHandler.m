//
//  SocketIOHandler.m
//  spotted
//
//  Created by BoHuang on 6/30/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "SocketIOHandler.h"
#import "Global.h"

@implementation SocketIOHandler

+ (instancetype)shared
{
    static SocketIOHandler *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SocketIOHandler alloc] init];
        
    });
    
    return sharedInstance;
}

-(id) init{

    return self;
}

-(void) signIn:(NSString*) userId {
    NSURL* url = [[NSURL alloc] initWithString:SITE_URL];
    self.socket = [[SocketIOClient alloc] initWithSocketURL:url config:@{@"log": @YES, @"forcePolling": @YES, @"reconnects":@YES, @"forceNew":@YES}];
    
    [self.socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        [self.socket emit:@"signin" with:@[@{@"_id" : userId }]];
    }];
    [self.socket connect];

}

-(void) connect {

}


-(void) configSocketIO {

}
@end
