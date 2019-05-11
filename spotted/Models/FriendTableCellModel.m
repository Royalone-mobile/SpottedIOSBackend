//
//  FriendTableCellModel.m
//  spotted
//
//  Created by BoHuang on 4/17/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "FriendTableCellModel.h"


@implementation FriendTableCellModel
- (id)init{
    if((self = [super init])) {
        self.mUser = [[UserModel alloc]init];
    }
    return self;
}

- (NSComparisonResult)compare:(FriendTableCellModel *)otherObject {
    NSString* first = [self.mUser.mUserName lowercaseString];
    NSString* second = [otherObject.mUser.mUserName lowercaseString];
    return [first compare:second];
}
@end
