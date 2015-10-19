////
////  ZZLoginViewController.m
////  Zzazan
////
////  Created by Yiming Jiang on 2/10/15.
////  Copyright (c) 2015 Yiming Jiang. All rights reserved.
////
//
//#import "ZZLoginViewController.h"
//#import <Parse/Parse.h>
//#import "ZZConstant.h"
//#import "ZZUtility.h"
//#import "SVProgressHUD.h"
//
//@interface ZZLoginViewController ()
//
//@property (strong, nonatomic) UITextField* name;
//@property (strong, nonatomic) UITextField* password;
//
//@end
//
//@implementation ZZLoginViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//    
//    int device = [ZZUtility getDeviceModel];
//    
//    // screen background
//    UIImage* backgroundImage;
//    if (device == iPhone6) {
//        backgroundImage = [UIImage imageNamed:@"SignupLoginBackground6.png"];
//    }
//    else if (device == iPhone5) {
//        backgroundImage = [UIImage imageNamed:@"WelcomeBackground5.png"];
//    }
//    UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage: backgroundImage];
//    backgroundImageView.frame = CGRectMake(0, 0, [ZZUtility getScreenWidth], [ZZUtility getScreenHeight]);
//    [self.view addSubview:backgroundImageView];
//    
//    // cancel button
//    CGRect cancelButtonSize;
//    UIImage *cancelImage;
//    if (device == iPhone6) {
//        cancelButtonSize = CGRectMake(608/2.0f, 113/2.0f, 33/2.0f, 33/2.0f);
//        cancelImage = [UIImage imageNamed:@"SignupLoginCancel6.png"];
//    }
//    else if (device == iPhone5) {
//        cancelButtonSize = CGRectMake(517/2.0f, 95/2.0f, 32/2.0f, 32/2.0f);
//        cancelImage = [UIImage imageNamed:@"SignupLoginCancel5.png"];
//        
//    }
//    UIButton* cancelButton = [[UIButton alloc] initWithFrame:cancelButtonSize];
//    [cancelButton setBackgroundImage:cancelImage forState:UIControlStateNormal];
//    [cancelButton addTarget:self action:@selector(pressCancelButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:cancelButton];
//    
//    // log in button text
//    CGRect loginTextSize;
//    UIImage* loginTextImage;
//    
//    if (device == iPhone6) {
//        loginTextSize = CGRectMake(319/2.0f, 667/2.0f, 87/2.0f, 17/2.0f);
//        loginTextImage = [UIImage imageNamed:@"LoginLoginButton6.png"];
//    }
//    else if (device == iPhone5) {
//        loginTextSize = CGRectMake(274/2.0f, 568/2.0f, 87/2.0f, 17/2.0f);
//        loginTextImage = [UIImage imageNamed:@"LoginLoginButton5.png"];
//    }
//    
//    UIImageView* loginText = [[UIImageView alloc] initWithFrame:loginTextSize];
//    loginText.image = loginTextImage;
//    [self.view addSubview:loginText];
//    
//    // log in button
//    CGRect loginButtonSize;
//    if (device == iPhone6) {
//        loginButtonSize = CGRectMake(183/2.0f, 623/2.0f, 411/2.0f, 126/2.0f);
//    }
//    else if (device == iPhone5) {
//        loginButtonSize = CGRectMake(202/2.0f, 525/2.0f, 226/2.0f, 115/2.0f);
//    }
//    
//    UIButton* loginButton = [[UIButton alloc] initWithFrame:loginButtonSize];
//    loginButton.accessibilityLabel = @"login";
//    [loginButton addTarget:self action:@selector(pressLoginButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:loginButton];
//    
//    // add lines
//    CGRect passwordLineSize, nameLineSize;
//    UIImage* lineImage;
//    if (device == iPhone6) {
//        nameLineSize = CGRectMake(145/2.0f, 299.5/2.0f, 463/2.0f, 1/2.0f);
//        passwordLineSize = CGRectMake(145/2.0f, 421.5/2.0f, 463/2.0f, 1/2.0f);
//        lineImage = [UIImage imageNamed:@"SignupLoginLine6.png"];
//    }
//    else if (device == iPhone5) {
//        nameLineSize = CGRectMake(123.5/2.0f, 258/2.0f, 394/2.0f, 2/2.0f);
//        passwordLineSize = CGRectMake(123.5/2.0f, 364/2.0f, 394/2.0f, 2/2.0f);
//        lineImage = [UIImage imageNamed:@"SignupLoginLine5.png"];
//    }
//    UIImageView* passwordLineView = [[UIImageView alloc] initWithFrame:passwordLineSize];
//    UIImageView* nameLineView = [[UIImageView alloc] initWithFrame:nameLineSize];
//    passwordLineView.image = lineImage;
//    nameLineView.image = lineImage;
//    [self.view addSubview:passwordLineView];
//    [self.view addSubview:nameLineView];
//    
//    // textfields
//    CGRect passwordSize, nameSize;
//    UIFont* textFont;
//    UIFont* placeholderFont;
//    if (device == iPhone6) {
//        nameSize = CGRectMake(120/2.0f, 236/2.0f, 512/2.0f, 63/2.0f);
//        passwordSize = CGRectMake(120/2.0f, 358/2.0f, 512/2.0f, 63/2.0f);
//        textFont = [UIFont fontWithName:@"Copperplate-Light" size:17];
//        placeholderFont = [UIFont fontWithName:@"Copperplate-Light" size:18];
//        
//    }
//    else if (device == iPhone5) {
//        nameSize = CGRectMake(106/2.0f, 193/2.0f, 416/2.0f, 55/2.0f);
//        passwordSize = CGRectMake(106/2.0f, 299/2.0f, 416/2.0f, 55/2.0f);
//        textFont = [UIFont fontWithName:@"Copperplate-Light" size:15];
//        placeholderFont = [UIFont fontWithName:@"Copperplate-Light" size:16];
//    }
//    
//    self.name=[[UITextField alloc] initWithFrame:nameSize];
//    self.password = [[UITextField alloc] initWithFrame:passwordSize];
//    
//    UIColor* textColor = [UIColor whiteColor];
//    
//    self.name.borderStyle = UITextBorderStyleRoundedRect;
//    self.name.textColor = textColor;
//    self.name.font = textFont;
//    
//    self.password.borderStyle = UITextBorderStyleRoundedRect;
//    self.password.textColor = textColor;
//    self.password.font = [UIFont systemFontOfSize:17];
//    self.password.secureTextEntry = YES;
//    
//    UIColor* placeholderColor = [UIColor whiteColor];
//    
//    self.name.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{NSFontAttributeName: placeholderFont, NSForegroundColorAttributeName: placeholderColor}];
//    self.name.backgroundColor = [UIColor clearColor];
//    self.name.accessibilityLabel = @"name";
//    self.name.delegate = self;
//    
//    self.password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSFontAttributeName: placeholderFont, NSForegroundColorAttributeName: placeholderColor}];
//    self.password.backgroundColor = [UIColor clearColor];
//    self.password.accessibilityLabel = @"password";
//    self.password.delegate = self;
//    
//    [self.view addSubview:self.name];
//    [self.view addSubview:self.password];
//    
//    // dismiss keyboard when touch outside
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
//    [self.view addGestureRecognizer:tap];
//}
//
//- (void) dismissKeyboard {
//    [self.name resignFirstResponder];
//    [self.password resignFirstResponder];
//}
//
//- (BOOL) textFieldShouldReturn: (UITextField *) textField {
//    [textField resignFirstResponder];
//    return YES;
//}
//
//- (void)pressCancelButton:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void)pressLoginButton:(id)sender {
//    [SVProgressHUD showWithStatus:@"Connecting"];
//    [PFUser logInWithUsernameInBackground:self.name.text password:self.password.text
//                                    block:^(PFUser *user, NSError *error) {
//        if (user) {
//            [SVProgressHUD dismiss];
//            [self presentViewController:[ZZUtility createMainViews] animated:YES completion:nil];
//        } else {
//            NSString *errorString = [error userInfo][@"error"];
//            [SVProgressHUD showErrorWithStatus:errorString];
//        }
//    }];
//}
//
//@end
