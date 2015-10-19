//
//  ZZActivityViewController.h
//  Zzazan
//
//  Created by Yiming Jiang on 2/10/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZActivityViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *activitylist;
@property (nonatomic, strong) NSMutableArray *activityInUse;
@property (nonatomic, strong) NSMutableArray *activityInUseDetail;
@end