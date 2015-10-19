//
//  ZZActivitiesSelectFriendsTableViewCell.m
//  Zzazan
//
//  Created by Yiming Jiang on 4/13/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import "ZZActivitiesSelectFriendsTableViewCell.h"
#import "ZZUtility.h"

static float const kAvatarToLeft5 = 43/2.0f;
static float const kAvatarToTop5 = 39/2.0f;
static float const kAvatarSize5 = 45;

static float const kNameToLeft5 = 189/2.0f;
static float const kNameToTop5 = 25;
static float const kNameWidth5 = 180;
static float const kNameHeight5 = 30;
static float const kNameFontSize5 = 16;

static float const kSelectButtonToTop5 = 0;
static float const kSelectButtonHeight5 = 133/2.0f;

static float const kSelectImageToRight = 40;
static float const kSelectImageToTop5 = 33;
static float const kSelectImageSize5 = 22;

@implementation ZZActivitiesSelectFriendsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
              model:(ZZActivitiesSelectFriends *)model {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // draw avatar
        CGRect avatarFrame = CGRectMake(kAvatarToLeft5, kAvatarToTop5, kAvatarSize5, kAvatarSize5);
        self.avatar = [[UIImageView alloc] initWithFrame: avatarFrame];
        self.avatar.layer.masksToBounds = YES;
        self.avatar.layer.cornerRadius = self.avatar.frame.size.height/2;
//        self.avatar.layer.borderWidth = 0.1f;
//        self.avatar.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.avatar.image = model.avatar;
        [self addSubview:self.avatar];
        
        // draw name label
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(kNameToLeft5, kNameToTop5, kNameWidth5, kNameHeight5)];
        self.name.font = [UIFont fontWithName:@"Copperplate-Light" size:kNameFontSize5];
        self.name.textColor = [UIColor blackColor];
        
        self.name.text = model.name;
        [self addSubview:self.name];
        
        // draw select button
        CGRect selectFrame = CGRectMake(kNameToLeft5+kNameWidth5, kSelectButtonToTop5, [ZZUtility getScreenWidth]-kNameToLeft5-kNameWidth5, kSelectButtonHeight5);
        self.selectButton = [[UIButton alloc] initWithFrame:selectFrame];
        [self addSubview:self.selectButton];
        [self.selectButton addTarget:self action:@selector(selectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        // draw select image
        self.selectImage = [[UIImageView alloc] initWithFrame: CGRectMake([ZZUtility getScreenWidth]-kSelectImageToRight, kSelectImageToTop5, kSelectImageSize5, kSelectImageSize5)];
        if (model.isSelected) {
            self.selectImage.image = [UIImage imageNamed:@"Checked5.png"];
        }
        else {
            self.selectImage.image = [UIImage imageNamed:@"Unchecked5.png"];
        }
        [self addSubview:self.selectImage];
    }
    return self;
}

- (void)selectButtonPressed:(id)sender {
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(didClickOnCellAtIndex:withCommand:)]) {
        [self.delegate didClickOnCellAtIndex:_cellIndex withCommand:@"select_a_friend"];
    }
}

@end
