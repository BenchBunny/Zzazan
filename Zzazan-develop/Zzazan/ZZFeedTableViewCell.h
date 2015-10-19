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

@protocol FeedCellDelegate <NSObject>

- (void)didClickOnCellAtIndex:(NSInteger)cellIndex withData:(id)data;

@end


@interface ZZFeedTableViewCell : UITableViewCell <TTTAttributedLabelDelegate>

@property (nonatomic, strong) TTTAttributedLabel *nameLabel;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UIImageView *photo;
@property (nonatomic, strong) UILabel *likeLabel;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *shareButton;

@property (weak, nonatomic) id<FeedCellDelegate>delegate;
@property (assign, nonatomic) NSInteger cellIndex;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
          postModel:(ZZFeedPost *)model;

@end
