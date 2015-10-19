//
//  ZZActivities.h
//  Zzazan
//
//  Created by Yiming Jiang on 4/13/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZActivities : NSObject

@property (strong, nonatomic) NSString *activity;
@property (assign, nonatomic) BOOL isOn;

- (instancetype)initWithActivity:(NSString *)name state:(BOOL) state1;

@end
