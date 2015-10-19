//
//  ZZActivitiesSelectFriendsViewController.h
//  Zzazan
//
//  Created by Yiming Jiang on 4/13/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZActivitiesSelectFriends.h"
#import "ZZActivitiesSelectFriendsTableViewCell.h"

@interface ZZActivitiesSelectFriendsViewController : UITableViewController <ActivitiesSelectFriendsDelegate>
@property (nonatomic, assign) NSInteger *selectedActivity;
@end
