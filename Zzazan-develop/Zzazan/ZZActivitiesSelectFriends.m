//
//  ZZActivitiesSelectFriends.m
//  Zzazan
//
//  Created by Yiming Jiang on 4/13/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import "ZZActivitiesSelectFriends.h"

@implementation ZZActivitiesSelectFriends

- (instancetype)initWithAvatar:(UIImage *)avatar
                          name:(NSString *)name
                         state:(BOOL) selectedState;
{
    self = [super init];
    if (self) {
        self.avatar = avatar;
        self.name = name;
        self.isSelected = selectedState;
    }
    return self;
}
@end
