//
//  ZZFeedTableViewCell.m
//  Zzazan
//
//  Created by Yiming Jiang on 3/17/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import "ZZActivityCell.h"
#import "ZZUtility.h"
//#import "ZZConstant.h"

// avatar image constants
static float const kAvatarToTop5 = 20;
static float const kAvatarToLeft5 = 20;
static float const kAvatarSize5 = 50;

// name label constants
static float const kNameToTop5 = kAvatarToTop5;
static float const kNameToLeft5 = kAvatarToLeft5+kAvatarSize5+20;
static float const kNameWidth5 = 200;
static float const kNameHeight5 = 30;
static float const kNameFontSize5 = 17;

// turned on label constants
static float const kTurnedOnLabelToTop5 = kNameToTop5+kNameHeight5+5;
static float const kTurnedOnLabelToLeft5 = kNameToLeft5+20;
static float const kTurnedOnLabelWidth5 = 80;
static float const kTurnedOnFontSize5 = 12;

// activity label constants
static float const kActivityLabelToTop5 = kTurnedOnLabelToTop5-5;
static float const kActivityLabelToLeft5 =kTurnedOnLabelToLeft5+kTurnedOnLabelWidth5;
static float const kActivityLabelWidth5 = 320-kActivityLabelToLeft5;
static float const kActivityLabelHeight5 = 30;
static float const kActivityLabelFontSize5 = 16;

@implementation ZZActivityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier postModel:(ZZFeedPost *)model {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // draw name label
        CGRect nameLabelFrame;
        NSMutableAttributedString *nameAttributedString;
        nameAttributedString = [[NSMutableAttributedString alloc] initWithString:model.name];
        [nameAttributedString addAttribute:NSForegroundColorAttributeName value: [UIColor blackColor] range:NSMakeRange(0,nameAttributedString.length)];
        nameLabelFrame = CGRectMake(kNameToLeft5 - 20, kNameToTop5 + 10, kNameWidth5, kNameHeight5);
        [nameAttributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:kNameFontSize5] range:NSMakeRange(0,nameAttributedString.length)];
        self.nameLabel = [[TTTAttributedLabel alloc] initWithFrame: nameLabelFrame];
        self.nameLabel.delegate = self;
        [self.nameLabel addLinkToTransitInformation:[NSDictionary dictionaryWithObject: nameAttributedString.string forKey:@"post_name"] withRange:NSMakeRange(0,nameAttributedString.length)];
        self.nameLabel.attributedText = nameAttributedString;
        [self addSubview:self.nameLabel];
        
        // draw turned on label
        CGRect turnedOnFrame;
        NSMutableAttributedString *turnedOnAttributedString = [[NSMutableAttributedString alloc] initWithString:model.date attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kTurnedOnFontSize5 - 4]}];
        turnedOnFrame = CGRectMake(kActivityLabelToLeft5 + 70, kActivityLabelToTop5 - 50, kActivityLabelWidth5, kActivityLabelHeight5);
        UILabel *turnedOnLabel = [[UILabel alloc] initWithFrame:turnedOnFrame];
        turnedOnLabel.attributedText = turnedOnAttributedString;
        [self addSubview:turnedOnLabel];
        
        // draw activity label
        CGRect activityFrame;
        NSMutableAttributedString *activityAttributedString = [[NSMutableAttributedString alloc] initWithString:model.activity attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:kActivityLabelFontSize5], NSForegroundColorAttributeName: RGBACOLOR(255, 230, 0, 1)}];
        activityFrame = CGRectMake(kActivityLabelToLeft5 + 25, kActivityLabelToTop5 - 20, kActivityLabelWidth5, kActivityLabelHeight5);
        UILabel *activityLabel = [[UILabel alloc] initWithFrame:activityFrame];
        activityLabel.attributedText = activityAttributedString;
        [self addSubview:activityLabel];
       
    }
    return self;
}

#pragma mark - TTTAttributedLabel delegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components {
    NSString *str = [components objectForKey:@"post_name"];
    NSLog(@"You are clicking %@", str);
}

@end
