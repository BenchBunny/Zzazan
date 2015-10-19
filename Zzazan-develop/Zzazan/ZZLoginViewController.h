//
//  ZZLoginViewController.h
//  Zzazan
//
//  Created by Yiming Jiang on 4/25/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZLoginViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *password;

@end
