//
//  NotificationModel.h
//  spotted
//
//  Created by BoHuang on 4/18/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationModel : NSObject
@property (strong, nonatomic) NSMutableDictionary* mParam;
@property (assign, nonatomic) long mType;
@property (strong, nonatomic) NSString* mId;
@property (strong, nonatomic) NSString* mReceiverId;

-(void) parse:(NSDictionary*) dict;
-(NSString*) getNotificationTitle;
-(NSString*) getNotificationMessage;
-(NSString*) getParam:(NSString*) key;

- (NSComparisonResult)compare:(NotificationModel *) otherObject;
@end
