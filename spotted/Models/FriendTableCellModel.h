//
//  FriendTableCellModel.h
//  spotted
//
//  Created by BoHuang on 4/17/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface FriendTableCellModel : NSObject

@property (strong, nonatomic) UserModel* mUser;
@property (assign, nonatomic) int mType;
@property (strong, nonatomic) NSString* mSectionTitle;
@property (assign, nonatomic) bool mChecked;


- (NSComparisonResult)compare:(FriendTableCellModel *) otherObject;
@end
