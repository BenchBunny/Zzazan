//
//  ZZConstant.h
//  Zzazan
//
//  Created by Yiming Jiang on 2/23/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#ifndef Zzazan_ZZConstant_h
#define Zzazan_ZZConstant_h

/****************************************************************
 ******************   ZZCommentTableViewCell ********************/

// name label constants
static float const kCommentNameLabelToLeft5 = 15;
static float const kCommentNameLabelToTop5 = 15;
static float const kCommentNameLabelWidth5 = 200;
static float const kCommentNameLabelHeight5 = 20;
static float const kCommentNameLabelFontSize5 = 13;

// comment label constants
static float const kCommentCommentLabelToLeft5 = kCommentNameLabelToLeft5;
static float const kCommentCommentLabelToTop5 = kCommentNameLabelToLeft5+kCommentNameLabelHeight5+2;
static float const kCommentCommentLabelWidth5 = 320-kCommentNameLabelToLeft5-20;
static float const kCommentCommentLabelFontSize5 = 12;

/****************************************************************/

/****************************************************************
 ******************    ZZFeedTableViewCell **********************/

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
static float const kTurnedOnLabelHeight5 = 20;
static float const kTurnedOnFontSize5 = 12;

// activity label constants
static float const kActivityLabelToTop5 = kTurnedOnLabelToTop5-5;
static float const kActivityLabelToLeft5 =kTurnedOnLabelToLeft5+kTurnedOnLabelWidth5;
static float const kActivityLabelWidth5 = 320-kActivityLabelToLeft5;
static float const kActivityLabelHeight5 = 30;
static float const kActivityLabelFontSize5 = 16;

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

/****************************************************************/

#endif
