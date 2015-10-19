//
//  ZZFeedPost.m
//  Zzazan
//
//  Created by Yiming Jiang on 3/17/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import "ZZFeedPost.h"

@implementation ZZFeedPost

- (instancetype)initWithName:(NSString *)name
                      AvatarURL:(NSString *)avatarURL
                    Activity:(NSString *)activity
               NumberOfLikes:(NSInteger)likes
                        Date:(NSString*)date
                    ObjectId:(NSString *)id {
    self = [super init];
    if (self) {
        self.name = name;
        self.avatarURL = avatarURL;
        self.likes = likes;
        self.activity = activity;
        self.comments = [NSMutableArray array];
        self.doILikeThisPost = NO;
        self.date = date;
        self.objectId = id;
    }
    return self;
}

- (void)addAComment:(ZZComment *)comment {
    [self.comments addObject:comment];
}

@end
