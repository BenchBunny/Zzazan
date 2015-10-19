//
//  ZZUtility.h
//  Zzazan
//
//  Created by Yiming Jiang on 2/23/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import <UIKit/UIKit.h>
#import "ZZContactsViewController.h"
#import "ZZActivityViewController.h"
#import "ZZMeViewController.h"
#import "ZZFeedViewController.h"
#import "ZZActivitiesViewController.h"

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@interface ZZUtility : NSObject

+ (CGFloat)getScreenWidth;

+ (CGFloat)getScreenHeight;

+ (UITabBarController *)createMainViews;

+ (CGFloat)calculateCommentLabelHeight:(NSString *)text
                         withViewWidth:(CGFloat)width
                              withFont:(UIFont *)font;

@end
