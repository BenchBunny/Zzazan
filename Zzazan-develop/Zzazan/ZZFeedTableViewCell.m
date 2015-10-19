//
//  ZZFeedTableViewCell.m
//  Zzazan
//
//  Created by Yiming Jiang on 3/17/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import "ZZFeedTableViewCell.h"
#import "ZZUtility.h"

// avatar image constants
static float const kAvatarToTop5 = 20;
static float const kAvatarToLeft5 = 20;
static float const kAvatarSize5 = 50;

// name label constants
static float const kNameToTop5 = kAvatarToTop5;
static float const kNameToLeft5 = kAvatarToLeft5+kAvatarSize5+20;
static float const kNameWidth5 = 200;
static float const kNameHeight5 = 30;
static float const kNameFontSize5 = 15;

// turned on label constants
static float const kTurnedOnLabelToTop5 = kNameToTop5+kNameHeight5+5;
static float const kTurnedOnLabelToLeft5 = kNameToLeft5+20;
static float const kTurnedOnLabelWidth5 = 80;
static float const kTurnedOnLabelHeight5 = 20;
static float const kTurnedOnFontSize5 = 14;

// activity label constants
static float const kActivityLabelToTop5 = kTurnedOnLabelToTop5-5;
static float const kActivityLabelToLeft5 =kTurnedOnLabelToLeft5+kTurnedOnLabelWidth5;
static float const kActivityLabelWidth5 = 320-kActivityLabelToLeft5;
static float const kActivityLabelHeight5 = 30;
static float const kActivityLabelFontSize5 = 20;

// like icon image constants
static float const kLikeIconAssetWidth5 = 40;
static float const kLikeIconAssetHeight5 = 36;

static float const kLikeIconToLeft5 = 20;
static float const kLikeIconToTop5 = kAvatarToTop5+kAvatarSize5+22;
static float const kLikeIconWidth5 = 15;
static float const kLikeIconHeight5 = kLikeIconWidth5*kLikeIconAssetHeight5/kLikeIconAssetWidth5;

// like label constants
static float const kLikeLabelToLeft5 = kLikeIconToLeft5+kLikeIconWidth5+10;
static float const kLikeLabelToTop5 = kLikeIconToTop5-2;
static float const kLikeLabelWidth5 = 100;
static float const kLikeLabelHeight5 = 18;
static float const kLikeLabelFont5 = 13;

// comment icon image constants
static float const kCommentIconAssetWidth5 = 40;
static float const KCommentIconAssetHeight5 = 32;
static float const kCommentIconToLeft5 = kLikeIconToLeft5;
static float const kCommentIconToTopWithLike5 = kLikeIconToTop5+kLikeIconHeight5+10;
static float const kCommentIconToTopWithoutLike5 = kLikeIconToTop5;
static float const kCommentIconWidth5 = kLikeIconWidth5;
static float const kCommentIconHeight5 = kCommentIconWidth5*KCommentIconAssetHeight5/kCommentIconAssetWidth5;

// comment label constants
static float const kCommentFontSize5 = 13;
static float const kCommentLabelToLeft5 = kLikeLabelToLeft5;
static float const kCommentLabelWidth5 = 320-10-kCommentLabelToLeft5;
static float const kCommentMargin5 = 0;

// view more comments button constants
static float const kViewMoreCommentsButtonToLeft5 = kLikeLabelToLeft5;
static float const kViewMoreCommentsButtonWidth5 = 200;
static float const kViewMoreCommentsButtonHeight5 = 15;
static float const kViewMoreCommentsButtonFontSize5 = 14;

// like button constants
static float const kLikeButtonAssetWidth5 = 132;
static float const kLikeButtonAssetHeight5 = 48;

static float const kLikeButtonToLeft5 = kLikeIconToLeft5;
static float const kLikeButtonWidth5 = kLikeButtonAssetWidth5/2;
static float const kLikeButtonHeight5 = kLikeButtonAssetHeight5/2;

// comment button constants
static float const kCommentButtonAssetWidth5 = 185;
static float const kCommentButtonAssetHeight5 = kLikeButtonAssetHeight5;

static float const kCommentButtonToLeft5 = kLikeButtonToLeft5+kLikeButtonWidth5+8;
static float const kCommentButtonWidth5 = kCommentButtonAssetWidth5/2;
static float const kCommentButtonHeight5 = kCommentButtonAssetHeight5/2;

@implementation ZZFeedTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier postModel:(ZZFeedPost *)model {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // draw avatar
        CGRect avatarFrame = CGRectMake(kAvatarToLeft5, kAvatarToTop5, kAvatarSize5, kAvatarSize5);
        self.avatar = [[UIImageView alloc] initWithFrame: avatarFrame];
        self.avatar.layer.masksToBounds = YES;
        self.avatar.layer.cornerRadius = self.avatar.frame.size.height/2;
        self.avatar.layer.borderWidth = 0.1f;
        self.avatar.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //self.avatar.image = model.avatar;
        [self addSubview:self.avatar];
        
        // draw name label
        NSMutableAttributedString *nameAttributedString;
        nameAttributedString = [[NSMutableAttributedString alloc] initWithString:model.name];
        [nameAttributedString addAttribute:NSForegroundColorAttributeName value: [UIColor blackColor] range:NSMakeRange(0,nameAttributedString.length)];
            CGRect nameLabelFrame = CGRectMake(kNameToLeft5, kNameToTop5, kNameWidth5, kNameHeight5);
        [nameAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Copperplate-Light" size:kNameFontSize5] range:NSMakeRange(0,nameAttributedString.length)];
        self.nameLabel = [[TTTAttributedLabel alloc] initWithFrame: nameLabelFrame];
        self.nameLabel.delegate = self;
        [self.nameLabel addLinkToTransitInformation:[NSDictionary dictionaryWithObject: nameAttributedString.string forKey:@"post_name"] withRange:NSMakeRange(0,nameAttributedString.length)];
        self.nameLabel.attributedText = nameAttributedString;
        [self addSubview:self.nameLabel];
        
        // draw turned on label
        NSMutableAttributedString *turnedOnAttributedString = [[NSMutableAttributedString alloc] initWithString:@"turned on" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Copperplate-Light" size:kTurnedOnFontSize5]}];
        CGRect turnedOnFrame = CGRectMake(kTurnedOnLabelToLeft5, kTurnedOnLabelToTop5, kTurnedOnLabelWidth5, kTurnedOnLabelHeight5);
        UILabel *turnedOnLabel = [[UILabel alloc] initWithFrame:turnedOnFrame];
        turnedOnLabel.attributedText = turnedOnAttributedString;
        [self addSubview:turnedOnLabel];
        
        CGFloat likeButtonPosition = 0.0f;
        
        // draw activity label
        NSMutableAttributedString *activityAttributedString = [[NSMutableAttributedString alloc] initWithString:model.activity attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Copperplate-Light" size:kActivityLabelFontSize5], NSForegroundColorAttributeName: RGBACOLOR(255, 230, 0, 1)}];
        CGRect activityFrame = CGRectMake(kActivityLabelToLeft5, kActivityLabelToTop5, kActivityLabelWidth5, kActivityLabelHeight5);
            likeButtonPosition = kAvatarToTop5+kAvatarSize5;
        UILabel *activityLabel = [[UILabel alloc] initWithFrame:activityFrame];
        activityLabel.attributedText = activityAttributedString;
        [self addSubview:activityLabel];
        
        if (model.likes != 0) {
            // draw like icon
            CGRect likeIconFrame = CGRectMake(kLikeIconToLeft5, kLikeIconToTop5, kLikeIconWidth5, kLikeIconHeight5);
            UIImage *likeIconImage = [UIImage imageNamed:@"LikeIcon5.png"];
            UIImageView *likeIcon = [[UIImageView alloc] initWithFrame:likeIconFrame];
            likeIcon.image = likeIconImage;
            [self addSubview:likeIcon];
            
            // draw like label
            CGRect likeLabelFrame = CGRectMake(kLikeLabelToLeft5, kLikeLabelToTop5, kLikeLabelWidth5, kLikeLabelHeight5);
            self.likeLabel = [[UILabel alloc] initWithFrame: likeLabelFrame];
            self.likeLabel.textColor = RGBACOLOR(242, 115, 135, 1);
            self.likeLabel.font = [UIFont fontWithName:@"Copperplate-Light" size:kLikeLabelFont5];
            if (model.likes == 1) {
                self.likeLabel.text = @"1 like";
            }
            else {
                self.likeLabel.text = [NSString stringWithFormat:@"%ld likes", (long)model.likes];
            }
            [self addSubview:self.likeLabel];
            likeButtonPosition = kLikeLabelToTop5+kLikeLabelHeight5;
        }
        
        if (model.comments.count != 0) {
            // draw comment icon
            CGRect commentIconFrame;
            UIImage *commentIconImage;
            if (model.likes != 0) {
                commentIconFrame = CGRectMake(kCommentIconToLeft5, kCommentIconToTopWithLike5, kCommentIconWidth5, kCommentIconHeight5);
            }
            else {
                commentIconFrame = CGRectMake(kCommentIconToLeft5, kCommentIconToTopWithoutLike5, kCommentIconWidth5, kCommentIconHeight5);
            }
            commentIconImage = [UIImage imageNamed:@"CommentIcon5.png"];
            UIImageView *commentIcon = [[UIImageView alloc] initWithFrame:commentIconFrame];
            commentIcon.image = commentIconImage;
            [self addSubview:commentIcon];
            
            // draw comments labels
            likeButtonPosition = [self drawCommentsUsingDataModel:model];
        }

        if (model.likes != 0 && model.comments.count != 0) {
            likeButtonPosition += 10;
        }
        else if (model.likes != 0 && model.comments.count == 0) {
            likeButtonPosition += 10;
        }
        else if (model.likes == 0 && model.comments.count != 0) {
            likeButtonPosition += 10;
        }
        else if (model.likes == 0 && model.comments.count == 0) {
            likeButtonPosition += 15;
        }
        
        // draw like button
        CGRect likeButtonFrame = CGRectMake(kLikeButtonToLeft5, likeButtonPosition, kLikeButtonWidth5, kLikeButtonHeight5);
        self.likeButton = [[UIButton alloc] initWithFrame:likeButtonFrame];
        if (!model.doILikeThisPost) {
            [self.likeButton setBackgroundImage:[UIImage imageNamed:@"LikeButtonNormal5.png"] forState:UIControlStateNormal];
        }
        else {
            [self.likeButton setBackgroundImage:[UIImage imageNamed:@"LikeButtonSelected5.png"] forState:UIControlStateNormal];
        }
        [self addSubview:self.likeButton];
        [self.likeButton addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        // draw comment button
        CGRect commentButtonFrame = CGRectMake(kCommentButtonToLeft5, likeButtonPosition, kCommentButtonWidth5, kCommentButtonHeight5);
        self.commentButton = [[UIButton alloc] initWithFrame:commentButtonFrame];
        [self.commentButton setBackgroundImage:[UIImage imageNamed:@"CommentButton5.png"] forState:UIControlStateNormal];
        [self addSubview:self.commentButton];
        [self.commentButton addTarget:self action:@selector(commentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];        
    }
    return self;
}

#pragma mark - FeedCellDelegate

- (void)likeButtonPressed:(UIButton *)sender {
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(didClickOnCellAtIndex:withData:)]) {
        [self.delegate didClickOnCellAtIndex:_cellIndex withData:@"like"];
    }
}

- (void)commentButtonPressed:(UIButton *)sender {
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(didClickOnCellAtIndex:withData:)]) {
        [self.delegate didClickOnCellAtIndex:_cellIndex withData:@"comment"];
    }
}

- (void)shareButtonPressed:(UIButton *)sender {
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(didClickOnCellAtIndex:withData:)]) {
        [self.delegate didClickOnCellAtIndex:_cellIndex withData:@"share"];
    }
}

- (void)viewMoreCommentsButtonPressed:(UIButton *)sender {
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(didClickOnCellAtIndex:withData:)]) {
        [self.delegate didClickOnCellAtIndex:_cellIndex withData:@"view_more_comments"];
    }
}

#pragma mark - TTTAttributedLabel delegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components {
    NSString *str = [components objectForKey:@"post_name"];
    NSLog(@"You are clicking %@", str);
}

#pragma mark - Helper functions

- (TTTAttributedLabel *)drawEachCommentLabelUsingModel:(ZZFeedPost *)model
                                  atCommentsArrayIndex:(int)index
                                         atYCoordinate:(CGFloat)yPosition {
    CGRect commentLabelFrame;
    CGFloat actualEachCommentHeight = 0;
    NSMutableAttributedString *eachCommentAttributedString;
    ZZComment *comment = model.comments[index];
    NSString *eachName = comment.name;
    NSString *eachContent = comment.content;
    NSString *eachCommentString = [NSString stringWithFormat:@"%@  %@", eachName, eachContent];
    eachCommentAttributedString = [[NSMutableAttributedString alloc] initWithString: eachCommentString];
    [eachCommentAttributedString addAttribute:NSForegroundColorAttributeName value: RGBACOLOR(183, 164, 156, 1) range:NSMakeRange(0,eachName.length)];
    

    actualEachCommentHeight = [ZZUtility calculateCommentLabelHeight:eachCommentString withViewWidth: kCommentLabelWidth5 withFont:[UIFont fontWithName:@"Copperplate-Light" size:kCommentFontSize5]];
    commentLabelFrame = CGRectMake(kCommentLabelToLeft5, yPosition, kCommentLabelWidth5, actualEachCommentHeight);
    [eachCommentAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Copperplate-Light" size:kCommentFontSize5+2] range:NSMakeRange(0,eachName.length)];
    [eachCommentAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kCommentFontSize5-1] range:NSMakeRange(eachName.length+2, eachContent.length)];

    TTTAttributedLabel *eachCommentLabel = [[TTTAttributedLabel alloc] initWithFrame: commentLabelFrame];
    eachCommentLabel.delegate = self;
    [eachCommentLabel addLinkToTransitInformation:[NSDictionary dictionaryWithObject: eachName forKey:@"post_name"] withRange:NSMakeRange(0,eachName.length)];
    eachCommentLabel.attributedText = eachCommentAttributedString;
    
    eachCommentLabel.numberOfLines = 0;
    eachCommentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    return eachCommentLabel;
}

- (CGFloat)drawCommentsUsingDataModel:(ZZFeedPost *)model {
    CGFloat position = 0.0f;
    CGFloat commentViewWidth = 0.0f, commentFontSize = 0.0f, commentMargin = 0.0f;
    CGFloat viewMoreCommentsToLeft = 0.0f, viewMoreCommentsWidth = 0.0f, viewMoreCommentsHeight = 0.0f, viewMoreCommentsFontSize = 0.0f;
    
    position = (model.likes != 0) ? kCommentIconToTopWithLike5 : kCommentIconToTopWithoutLike5;
    commentViewWidth = kCommentLabelWidth5;
    commentFontSize = kCommentFontSize5;
    commentMargin = kCommentMargin5;
    viewMoreCommentsToLeft = kViewMoreCommentsButtonToLeft5;
    viewMoreCommentsWidth = kViewMoreCommentsButtonWidth5;
    viewMoreCommentsHeight = kViewMoreCommentsButtonHeight5;
    viewMoreCommentsFontSize = kViewMoreCommentsButtonFontSize5;
    
    if (model.comments.count > 0 && model.comments.count <= 5) {
        for (int i = 0; i < model.comments.count; i++) {
            TTTAttributedLabel *eachCommentLabel = [self drawEachCommentLabelUsingModel:model atCommentsArrayIndex:i atYCoordinate:position];
            [self addSubview: eachCommentLabel];
            ZZComment *eachComment = model.comments[i];
            NSString *eachCommentString = [NSString stringWithFormat:@"%@  %@", eachComment.name, eachComment.content];
            position += [ZZUtility calculateCommentLabelHeight:eachCommentString withViewWidth:commentViewWidth withFont:[UIFont fontWithName:@"Copperplate-Light" size:commentFontSize]];
            position += commentMargin;
        }
    }
    else {
        CGRect viewMoreCommentsButtonFrame = CGRectMake(viewMoreCommentsToLeft, position, viewMoreCommentsWidth, viewMoreCommentsHeight);
        UIButton *viewMoreCommentsButton = [[UIButton alloc] initWithFrame:viewMoreCommentsButtonFrame];
        viewMoreCommentsButton.backgroundColor = [UIColor whiteColor];
        [viewMoreCommentsButton setAttributedTitle:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"view all %ld comments", (unsigned long)model.comments.count] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Copperplate-Light" size:viewMoreCommentsFontSize], NSForegroundColorAttributeName: [UIColor lightGrayColor]}] forState:UIControlStateNormal];
        viewMoreCommentsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:viewMoreCommentsButton];
        [viewMoreCommentsButton addTarget:self action:@selector(viewMoreCommentsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        position += viewMoreCommentsHeight;
        position += commentMargin+3;
        
        for (int i = (int)model.comments.count-5; i < model.comments.count; i++) {
            TTTAttributedLabel *eachCommentLabel = [self drawEachCommentLabelUsingModel:model atCommentsArrayIndex:i atYCoordinate:position];
            [self addSubview: eachCommentLabel];
            ZZComment *eachComment = model.comments[i];
            NSString *eachCommentString = [NSString stringWithFormat:@"%@  %@", eachComment.name, eachComment.content];
            position += [ZZUtility calculateCommentLabelHeight:eachCommentString withViewWidth:commentViewWidth withFont:[UIFont fontWithName:@"Copperplate-Light" size:commentFontSize]];
            position += commentMargin;
        }
    }
    return position;
}

- (void)updateLikeNumberLabel:(NSInteger)newLikeCount {
    self.likeLabel.text = [NSString stringWithFormat:@"%ld likes", (long)newLikeCount];
}

@end
