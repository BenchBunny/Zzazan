//
//  ZZUtility.m
//  Zzazan
//
//  Created by Yiming Jiang on 2/23/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import "ZZUtility.h"

@implementation ZZUtility

+ (UITabBarController *)createMainViews {
    UITabBarController* tabBarController = [[UITabBarController alloc] init];
    
    UITableViewController* activitiesVC = [[ZZActivitiesViewController alloc] init];
    UIViewController* matchesVC = [[ZZActivityViewController alloc] init];
    UIViewController* homeVC = [[ZZMeViewController alloc] init];
    UITableViewController *circleVC = [[ZZFeedViewController alloc] init];
    
    UINavigationController* activitiesNavController = [[UINavigationController alloc] initWithRootViewController:activitiesVC];
    UINavigationController* matchesNavController = [[UINavigationController alloc] initWithRootViewController:matchesVC];
    UINavigationController* homeNavController = [[UINavigationController alloc] initWithRootViewController:homeVC];
    UINavigationController* circleNavController = [[UINavigationController alloc] initWithRootViewController:circleVC];
    
    activitiesNavController.tabBarItem.title = @"Activities";
    matchesNavController.tabBarItem.title = @"Matches";
    homeNavController.tabBarItem.title = @"Home";
    circleNavController.tabBarItem.title = @"Circle";
    
    // activities
    
    UIImage *activitiesImage = [UIImage imageNamed:@"ActivitiesTabIconNormal.png"];
    activitiesImage = [activitiesImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *activitiesImageSelected = [UIImage imageNamed:@"ActivitiesTabIconSelected.png"];
    activitiesImageSelected = [activitiesImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    activitiesNavController.tabBarItem.image = activitiesImage;
    activitiesNavController.tabBarItem.selectedImage = activitiesImageSelected;
    
    // matches
    
    UIImage *matchesImage = [UIImage imageNamed:@"MatchesTabIconNormal.png"];
    matchesImage = [matchesImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *matchesImageSelected = [UIImage imageNamed:@"MatchesTabIconSelected.png"];
    matchesImageSelected = [matchesImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    matchesNavController.tabBarItem.image = matchesImage;
    matchesNavController.tabBarItem.selectedImage = matchesImageSelected;
    
    // circle
    
    UIImage *circleImage = [UIImage imageNamed:@"CircleTabIconNormal.png"];
    circleImage = [circleImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *circleImageSelected = [UIImage imageNamed:@"CircleTabIconSelected.png"];
    circleImageSelected = [circleImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    circleNavController.tabBarItem.image = circleImage;
    circleNavController.tabBarItem.selectedImage = circleImageSelected;
    
    // home
    
    UIImage *homeImage = [UIImage imageNamed:@"HomeTabIconNormal.png"];
    homeImage = [homeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *homeImageSelected = [UIImage imageNamed:@"HomeTabIconSelected.png"];
    homeImageSelected = [homeImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    homeNavController.tabBarItem.image = homeImage;
    homeNavController.tabBarItem.selectedImage = homeImageSelected;
    
    // set translucent to NO
    
    activitiesNavController.navigationBar.translucent = NO;
    matchesNavController.navigationBar.translucent = NO;
    homeNavController.navigationBar.translucent = NO;
    circleNavController.navigationBar.translucent = NO;
    
    NSArray* controllers = [NSArray arrayWithObjects:activitiesNavController, matchesNavController, circleNavController, homeNavController, nil];
    
    tabBarController.viewControllers = controllers;
    
    return tabBarController;
}

+ (CGFloat)getScreenWidth {
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)getScreenHeight {
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGFloat)calculateCommentLabelHeight:(NSString *)text
                         withViewWidth:(CGFloat)width
                              withFont:(UIFont *)font {
    CGSize size;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return ceil(size.height);
}

@end
