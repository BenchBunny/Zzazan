//
//  ZZActivitiesSelectFriends.h
//  Zzazan
//
//  Created by Yiming Jiang on 4/13/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZZActivitiesSelectFriends : NSObject

@property (strong, nonatomic) UIImage *avatar;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) BOOL isSelected;

- (instancetype)initWithAvatar:(UIImage *)avatar
                          name:(NSString *)name
                         state:(BOOL) selectedState;

@end
