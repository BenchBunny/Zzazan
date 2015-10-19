//
//  ZZActivitiesSelectFriendsTableViewCell.h
//  Zzazan
//
//  Created by Yiming Jiang on 4/13/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZActivitiesSelectFriends.h"

@protocol ActivitiesSelectFriendsDelegate <NSObject>

- (void)didClickOnCellAtIndex:(NSInteger)cellIndex withCommand:(NSString *)command;

@end


@interface ZZActivitiesSelectFriendsTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIImageView *selectImage;

@property (weak, nonatomic) id<ActivitiesSelectFriendsDelegate>delegate;
@property (assign, nonatomic) NSInteger cellIndex;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
       model:(ZZActivitiesSelectFriends *)model;

@end
