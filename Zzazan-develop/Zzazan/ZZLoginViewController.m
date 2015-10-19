//
//  ZZLoginViewController.m
//  Zzazan
//
//  Created by Yiming Jiang on 4/25/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import "ZZLoginViewController.h"
#import <Parse/Parse.h>
#import "ZZUtility.h"
#import "SVProgressHUD.h"
#import "IonIcons.h"

@interface ZZLoginViewController ()

@end

@implementation ZZLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // cancel button
    UIImage *cancelImage = [IonIcons imageWithIcon:ion_ios_close_empty
                                         iconColor:[UIColor whiteColor]
                                          iconSize:35.0f
                                         imageSize:self.cancelButton.frame.size];
    [self.cancelButton setBackgroundImage:cancelImage forState:UIControlStateNormal];
    
    // configure textfields
    UIFont *textFont = [UIFont fontWithName:@"Copperplate-Light" size:17];
    UIFont *placeholderFont = [UIFont fontWithName:@"Copperplate-Light" size:18];
    
    UIColor *textColor = [UIColor whiteColor];
    
    self.name.textColor = textColor;
    self.name.font = textFont;
    
    self.password.textColor = textColor;
    self.password.font = textFont;
    self.password.secureTextEntry = YES;
    
    
    UIColor *placeholderColor = [UIColor whiteColor];
    
    self.name.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{NSFontAttributeName: placeholderFont, NSForegroundColorAttributeName: placeholderColor}];
    self.name.delegate = self;
    
    self.password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSFontAttributeName: placeholderFont, NSForegroundColorAttributeName: placeholderColor}];
    self.password.delegate = self;
    
    // dismiss keyboard when touch outside
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
}

- (void) dismissKeyboard {
    [self.name resignFirstResponder];
    [self.password resignFirstResponder];
}

- (BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginButtonClicked:(id)sender {
    [SVProgressHUD showWithStatus:@"Connecting"];
    [PFUser logInWithUsernameInBackground:self.name.text password:self.password.text
                                    block:^(PFUser *user, NSError *error) {
        if (user) {
            [SVProgressHUD dismiss];
            [self presentViewController:[ZZUtility createMainViews] animated:YES completion:nil];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            [SVProgressHUD showErrorWithStatus:errorString];
        }
    }];
}
@end
