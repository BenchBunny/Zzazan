//
//  ZZActivitiesTableViewCell.m
//  Zzazan
//
//  Created by Yiming Jiang on 4/13/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import "ZZActivitiesTableViewCell.h"
#import "ZZUtility.h"

static float const kCellHeight5 = 176/2.0f;
static float const kActivityWidth5 = 150;
static float const kActivityHeight5 = 30;
static float const kActivityToLeft5 = 76/2.0f;
static float const kActivityToTop5 = (kCellHeight5-kActivityHeight5)/2.0f;
static float const kActivityFontSize5 = 23;

static float const kArrowToTop5 = (200-128)/2.0f;
static float const kArrowToRight = 51;
static float const kArrowWidth5 = 32/2.0f;
static float const kArrowHeight5 = 37/2.0f;

static float const kTurnOnActivityToLeft5 = 22;
static float const kTurnOnActivityToTop5 = 17;
static float const kTurnOnActivityWidth5 = 276/2.0f;
static float const kTurnOnActivityHeight5 = 114/2.0f;

static float const kSelectFriendsToLeft5 = 431/2.0f;
static float const kSelectFriendsToTop5 = kTurnOnActivityToTop5;
static float const kSelectFriendsWidth5 = 209/2.0f;
static float const kSelectFriendsHeight5 = 114/2.0f;

@implementation ZZActivitiesTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
              model:(ZZActivities *)activity {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // draw activity
        self.activity = [[UILabel alloc] initWithFrame:CGRectMake(kActivityToLeft5, kActivityToTop5, kActivityWidth5, kActivityHeight5)];
        self.activity.font = [UIFont fontWithName:@"Copperplate-Light" size:kActivityFontSize5];
        if (activity.isOn) {
            self.activity.textColor = RGBACOLOR(232, 90, 113, 1.0);
        }
        else {
            self.activity.textColor = [UIColor blackColor];
        }
        
        self.activity.text = activity.activity;
        [self addSubview:self.activity];
        
        // draw arrow
        UIImage *arrowImage;
        if (!activity.isOn) {
            arrowImage = [UIImage imageNamed:@"ActivitiesArrow5.png"];
        }
        else {
            arrowImage = [UIImage imageNamed:@"ActivitiesArrowOn5.png"];
        }
        
        CGFloat screenWidth = [ZZUtility getScreenWidth];
        
        self.arrow = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-kArrowToRight-kArrowWidth5, kArrowToTop5, kArrowWidth5, kArrowHeight5)];
        self.arrow.image = arrowImage;
        [self addSubview:self.arrow];
        
        // draw buttons
        self.turnOnActivity = [[UIButton alloc] initWithFrame:CGRectMake(kTurnOnActivityToLeft5, kTurnOnActivityToTop5, kTurnOnActivityWidth5, kTurnOnActivityHeight5)];
        [self.turnOnActivity addTarget:self action:@selector(turnOnActivityPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.turnOnActivity];
        
        self.selectFriends = [[UIButton alloc] initWithFrame:CGRectMake(kSelectFriendsToLeft5, kSelectFriendsToTop5, kSelectFriendsWidth5, kSelectFriendsHeight5)];
        [self.selectFriends addTarget:self action:@selector(selectFriendsPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.selectFriends];
    }
    return self;
}

- (void)turnOnActivityPressed:(id)sender {
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(didClickOnCellAtIndex:withCommand:)]) {
        [self.delegate didClickOnCellAtIndex:_cellIndex withCommand:@"turn_on_activity"];
    }
}

- (void)selectFriendsPressed:(id)sender {
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(didClickOnCellAtIndex:withCommand:)]) {
        [self.delegate didClickOnCellAtIndex:_cellIndex withCommand:@"select_friends"];
    }
}

@end
