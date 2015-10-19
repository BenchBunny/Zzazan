//
//  ZZComment.h
//  Zzazan
//
//  Created by Yiming Jiang on 3/17/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZComment : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *content;

- (instancetype)initWithName:(NSString *)name
                     Comment:(NSString *)content;

@end
