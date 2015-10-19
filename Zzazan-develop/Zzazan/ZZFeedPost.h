//
//  ZZFeedPost.h
//  Zzazan
//
//  Created by Yiming Jiang on 3/17/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZZComment.h"

@interface ZZFeedPost : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *avatarURL;
@property (strong, nonatomic) NSString *activity;
@property (assign, nonatomic) NSInteger likes;
@property (strong, nonatomic) NSMutableArray *comments;
@property (assign, nonatomic) BOOL doILikeThisPost;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *objectId;

- (instancetype)initWithName:(NSString *)name
                      AvatarURL:(NSString *)avatarURL
                    Activity:(NSString *)activity
               NumberOfLikes: (NSInteger)likes
                        Date:(NSString *)date
                    ObjectId:(NSString *)id;

- (void)addAComment:(ZZComment *)comment;

@end
