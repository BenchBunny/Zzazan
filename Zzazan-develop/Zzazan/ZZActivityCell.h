//
//  ZZFeedTableViewCell.h
//  Zzazan
//
//  Created by Yiming Jiang on 3/17/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#import "ZZFeedPost.h"
#import "ZZComment.h"

@interface ZZActivityCell : UITableViewCell <TTTAttributedLabelDelegate>

@property (nonatomic, strong) TTTAttributedLabel *nameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
          postModel:(ZZFeedPost *)model;

@end
