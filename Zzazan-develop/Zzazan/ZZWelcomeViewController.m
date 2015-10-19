//
//  ZZWelcomeViewController.m
//  Zzazan
//
//  Created by Yiming Jiang on 4/19/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import "ZZWelcomeViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "ZZSignupViewController.h"
#import "ZZLoginViewController.h"
#import "SVProgressHUD.h"
#import "ZZUtility.h"
#import "EGOCache.h"

@interface ZZWelcomeViewController ()

@end

@implementation ZZWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGFloat screenWidth = [ZZUtility getScreenWidth];
    CGFloat ratio = 88/750;
    
    // draw log in here button
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(ratio*screenWidth, [ZZUtility getScreenHeight]-40, screenWidth*(1-(2*ratio)), 40)];
    [loginButton setTitle:@"Have an account? Log in here" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont fontWithName:@"Copperplate-Light" size:13];
    [loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
}
- (IBAction)facebookButtonPressed:(id)sender {
    NSArray* permissionArray = @[@"email"];
    
    [SVProgressHUD showWithStatus:@"Connecting"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionArray block:^(PFUser *user, NSError *error) {
        [SVProgressHUD dismiss];
        if (!user) {
            NSString *errorMessage = nil;
            if (!error) {
                errorMessage = @"The user cancelled the Facebook login.";
            } else {
                errorMessage = [error localizedDescription];
            }
            [SVProgressHUD showErrorWithStatus:errorMessage];
        } else {
            if (user.isNew) {
                NSLog(@"User with facebook signed up and logged in!");
                FBRequest *request = [FBRequest requestForMe];
                [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    // handle response
                    if (!error) {
                        // Parse the data received
                        NSDictionary *userData = (NSDictionary *)result;
                        /** keys include:
                         gender, locale, id, update_time, last_name,
                         timezone, link, verified, name, first_name, email
                         **/
                        //                for(NSString* key in [userData allKeys]) {
                        //                    NSLog(@"[%@, %@]\n", key, [userData objectForKey:key]);
                        //                }
                        
                        NSString *facebookID = userData[@"id"];
                        
                        NSString *name = userData[@"name"];
                        
                        NSString *email = userData[@"email"];
                        
                        NSString *userProfilePhotoURLString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
                        
                        [[PFUser currentUser] setUsername:name];
                        [[PFUser currentUser] setEmail:email];
                        [[PFUser currentUser] saveInBackground];
                        
                        PFObject *newUser = [PFObject objectWithClassName:@"FriendRelation"];
                        newUser[@"Username"] = name;
                        [newUser saveInBackground];
                        
                        // Download the user's facebook profile picture
                        if (userProfilePhotoURLString) {
                            NSURL *pictureURL = [NSURL URLWithString:userProfilePhotoURLString];
                            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
                            
                            [NSURLConnection sendAsynchronousRequest:urlRequest
                                                               queue:[NSOperationQueue mainQueue]
                                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                                       if (connectionError == nil && data != nil) {
                                                           UIImage* originalAvatar = [UIImage imageWithData:data];
                                                           CGFloat originalAvatarWidth = originalAvatar.size.width;
                                                           CGFloat originalAvatarHeight = originalAvatar.size.height;
                                                           CGRect clippedRect = CGRectMake((originalAvatarWidth-100)/2.0f, (originalAvatarHeight-100)/2.0f, 100, 100);
                                                           CGImageRef imageRef = CGImageCreateWithImageInRect([originalAvatar CGImage], clippedRect);
                                                           UIImage* newAvatar = [UIImage imageWithCGImage:imageRef];
                                                           PFFile* avatarFile = [PFFile fileWithData:UIImageJPEGRepresentation(newAvatar, 0.9f)];
                                                           [[PFUser currentUser] setObject:avatarFile forKey:@"avatar"];
                                                           [[PFUser currentUser] saveInBackground];
                                                           [[EGOCache globalCache] setImage:newAvatar forKey:@"avatar"];
                                                       } else {
                                                           NSLog(@"Failed to load profile photo.");
                                                       }
                                                   }];
                        }
                    } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                                isEqualToString: @"OAuthException"]) {
                        // Since the request failed, we can check if it was due to an invalid session
                        NSLog(@"The facebook session was invalidated");
                    } else {
                        NSLog(@"Some other error: %@", error);
                    }
                }];
                
            } else {
                NSLog(@"User with facebook logged in!");
            }
            [self presentViewController:[ZZUtility createMainViews] animated:YES completion:nil];
        }
    }];

}

- (IBAction)signupButtonPressed:(id)sender {
    ZZSignupViewController* signupVC = [[ZZSignupViewController alloc] init];
    [self presentViewController:signupVC animated:YES completion:nil];
}

- (void)loginButtonPressed:(id)sender {
    ZZLoginViewController* loginVC = [[ZZLoginViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:nil];
}
@end
