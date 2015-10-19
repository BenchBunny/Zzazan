//
//  ZZActivities.m
//  Zzazan
//
//  Created by Yiming Jiang on 4/13/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import "ZZActivities.h"

@implementation ZZActivities

- (instancetype)initWithActivity:(NSString *)name state:(BOOL) state1{
    self = [super init];
    if (self) {
        self.activity = name;
        self.isOn = state1;
    }
    return self;
}

@end
