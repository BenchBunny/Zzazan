//
//  ZZCommentsTableViewCell.h
//  Zzazan
//
//  Created by Yiming Jiang on 4/7/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZComment.h"
#import "TTTAttributedLabel.h"
#import "ZZUtility.h"

@interface ZZCommentsTableViewCell : UITableViewCell <TTTAttributedLabelDelegate>

@property (strong, nonatomic) TTTAttributedLabel *nameLabel;
@property (strong, nonatomic) UILabel *commentLabel;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
           comment:(ZZComment *)comment;

@end
