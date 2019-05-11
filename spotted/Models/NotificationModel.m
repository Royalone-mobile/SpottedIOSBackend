//
//  NotificationModel.m
//  spotted
//
//  Created by BoHuang on 4/18/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "NotificationModel.h"

@implementation NotificationModel
- (id)init{
    if((self = [super init])) {
        self.mParam = [[NSMutableDictionary alloc]init];
    }
    return self;
}
-(void) parse:(NSDictionary*) dict {
    
    if (self) {
        if([dict objectForKey:@"_id"] != nil)
        {
            self.mId = (NSString*)[dict objectForKey:@"_id"];
        }
        if([dict objectForKey:@"receiverId"] != nil)
        {
            self.mReceiverId = (NSString*)[dict objectForKey:@"receiverId"];
        }
        if([dict objectForKey:@"type"] != nil)
        {
            self.mType = [[dict objectForKey:@"type"] integerValue];
        }
        if(self.mType == 600 || self.mType == 100){
            if ([dict objectForKey:@"data"] != nil) {
                NSString* paramData = [dict  objectForKey:@"data"];
                
                NSError *jsonError;
                NSData *objectData = [paramData dataUsingEncoding:NSUTF8StringEncoding];
                self.mParam = [NSJSONSerialization JSONObjectWithData:objectData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&jsonError];
                
            }
        }else {
            if ([dict objectForKey:@"data"] != nil) {
                
                self.mParam = [dict objectForKey:@"data"];
            }
        }

        
        
    }
}

-(NSString*) getParam:(NSString*) key{
    return [self.mParam objectForKey:key];
    
}


- (NSString*) getNotificationTitle{
    switch (self.mType) {
        case 100:
            return @"Invited";
            break;
        case 200:
            return @"Spotted";
        case 300:
            return @"Judge";
        case 500:
            return @"Congratulations!";
        case 600:
            return @"Friend Request";
            
        case 700:
            return @"Spotted";
        default:
            break;
    }
    return @"";
}

- (NSString*) getNotificationMessage{
    switch (self.mType) {
        case 100:
            return @"You are invited to a game.";
            break;
        case 200:
            return @"Please take a photo of the task.";
            break;
        case 300:
            return @"Please judge the round.";						
            break;
        case 500:
            return @"You won the Game.";
            break;
        case 600: {
            NSString* requesterName = [self getParam:@"firstName"];
            if(requesterName == nil) {
                return @"A user want to be a friend with you.";
            }else {
                return [NSString stringWithFormat:@"%@ want to be a friend with you.", requesterName];
            }
        }
            break;
        case 700:
            return @"Judging Complete, View Images?";
            break;
        default:
            break;
    }
    return @"";
}

- (NSComparisonResult)compare:(NotificationModel *)otherObject {
    NSNumber* type = [NSNumber numberWithLong:self.mType];
    NSNumber* otherType = [NSNumber numberWithLong: otherObject.mType];
     return [type compare:otherType];
}

@end
