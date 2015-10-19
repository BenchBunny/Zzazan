//
//  ZZContactsTableViewCell.h
//  Zzazan
//
//  Created by Xing Gong on 2/18/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZContactsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *signature;

@end
