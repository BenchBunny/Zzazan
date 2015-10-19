//
//  ZZActivitiesTableViewCell.h
//  Zzazan
//
//  Created by Yiming Jiang on 4/13/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZActivities.h"

@protocol ActivitiesDelegate <NSObject>

- (void)didClickOnCellAtIndex:(NSInteger)cellIndex withCommand:(NSString *)command;

@end

@interface ZZActivitiesTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *activity;
@property (nonatomic, strong) UIImageView *arrow;

@property (nonatomic, strong) UIButton *turnOnActivity;
@property (nonatomic, strong) UIButton *selectFriends;

@property (weak, nonatomic) id<ActivitiesDelegate>delegate;
@property (assign, nonatomic) NSInteger cellIndex;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
              model:(ZZActivities *)activity;

@end
