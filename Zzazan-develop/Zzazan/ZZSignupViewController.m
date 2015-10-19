//
//  ZZSignupViewController.m
//  Zzazan
//
//  Created by Yiming Jiang on 4/25/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import "ZZSignupViewController.h"
#import <Parse/Parse.h>
#import "ZZConstant.h"
#import "ZZUtility.h"
#import "SVProgressHUD.h"
#import "IGIdenticon.h"
#import "IonIcons.h"
#import "EGOCache.h"

@interface ZZSignupViewController () <UITextFieldDelegate>

@end

@implementation ZZSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.rr
    
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
    
    self.email.textColor = textColor;
    self.email.font = textFont;
    
    self.password.textColor = textColor;
    self.password.font = textFont;
    self.password.secureTextEntry = YES;
    
    self.name.textColor = textColor;
    self.name.font = textFont;
    
    UIColor *placeholderColor = [UIColor whiteColor];
    
    self.email.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSFontAttributeName: placeholderFont, NSForegroundColorAttributeName: placeholderColor}];
    self.email.delegate = self;
    
    self.password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSFontAttributeName: placeholderFont, NSForegroundColorAttributeName: placeholderColor}];
    self.password.delegate = self;
    
    self.name.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{NSFontAttributeName: placeholderFont, NSForegroundColorAttributeName: placeholderColor}];
    self.name.delegate = self;

    // dismiss keyboard when touch outside
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
}

- (void) dismissKeyboard {
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
    [self.name resignFirstResponder];
}

- (BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signupButtonClicked:(id)sender {
    PFUser *user = [PFUser user];
    user.username = self.name.text;
    user.password = self.password.text;
    user.email = self.email.text;
    PFObject *newUser = [PFObject objectWithClassName:@"FriendRelation"];
    newUser[@"Username"] = user.username;
    [newUser saveInBackground];

    [SVProgressHUD showWithStatus:@"Connecting"];

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [SVProgressHUD dismiss];
            UIImage *identicon = [IGIdenticon identiconWithString:self.name.text size:256 backgroundColor:[UIColor whiteColor]];
            PFFile* avatarFile = [PFFile fileWithData:UIImageJPEGRepresentation(identicon, 0.9f)];
            [[PFUser currentUser] setObject:avatarFile forKey:@"avatar"];
            [[PFUser currentUser] saveInBackground];
            [[EGOCache globalCache] setImage:identicon forKey:@"avatar"];
            [self presentViewController:[ZZUtility createMainViews] animated:YES completion:nil];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            [SVProgressHUD showErrorWithStatus:errorString];
        }
    }];
}

@end
