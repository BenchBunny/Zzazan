//
//  ZZCommentsTableViewCell.m
//  Zzazan
//
//  Created by Yiming Jiang on 4/7/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import "ZZCommentsTableViewCell.h"
#import "ZZConstant.h"

@implementation ZZCommentsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
           comment:(ZZComment *)comment {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // draw name label
        CGRect nameLabelFrame;
        NSMutableAttributedString *nameAttributedString;
        nameAttributedString = [[NSMutableAttributedString alloc] initWithString:comment.name];
        [nameAttributedString addAttribute:NSForegroundColorAttributeName value: RGBACOLOR(183, 164, 156, 1) range:NSMakeRange(0,nameAttributedString.length)];
        nameLabelFrame = CGRectMake(kCommentNameLabelToLeft5, kCommentNameLabelToTop5, kCommentNameLabelWidth5, kCommentNameLabelHeight5);
        [nameAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kCommentNameLabelFontSize5] range:NSMakeRange(0,nameAttributedString.length)];
        self.nameLabel = [[TTTAttributedLabel alloc] initWithFrame: nameLabelFrame];
        //self.nameLabel.delegate = self;
        //[self.nameLabel addLinkToTransitInformation:[NSDictionary dictionaryWithObject: nameAttributedString.string forKey:@"post_name"] withRange:NSMakeRange(0,nameAttributedString.length)];
        self.nameLabel.attributedText = nameAttributedString;
        [self addSubview:self.nameLabel];
        
        // draw comment label
        CGRect commentLabelFrame;
        CGFloat height;
        height = [ZZUtility calculateCommentLabelHeight:comment.content withViewWidth:kCommentCommentLabelWidth5 withFont:[UIFont systemFontOfSize:kCommentCommentLabelFontSize5]];
        commentLabelFrame = CGRectMake(kCommentCommentLabelToLeft5, kCommentCommentLabelToTop5, kCommentCommentLabelWidth5, height);
        self.commentLabel = [[UILabel alloc] initWithFrame: commentLabelFrame];
        //self.commentLabel.textColor = RGBACOLOR(242, 115, 135, 1);
        self.commentLabel.font = [UIFont systemFontOfSize:kCommentCommentLabelFontSize5];
        self.commentLabel.text = comment.content;
        
        self.commentLabel.numberOfLines = 0;
        self.commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self addSubview:self.commentLabel];

    }
    return self;
}

@end
