//
//  ZZComment.m
//  Zzazan
//
//  Created by Yiming Jiang on 3/17/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import "ZZComment.h"

@implementation ZZComment

- (instancetype)initWithName:(NSString *)name Comment:(NSString *)content {
    self = [super init];
    if (self) {
        self.name = name;
        self.content = content;
    }
    return self;
}

@end
