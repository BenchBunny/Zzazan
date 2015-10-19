//
//  ZZMeViewController.m
//  Zzazan
//
//  Created by Yiming Jiang on 2/10/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import "ZZMeViewController.h"
#import <Parse/Parse.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "ZZSettingsViewController.h"
#import "ZZContactsViewController.h"
#import "ZZAddFriendViewController.h"
#import "ZZAcceptFriendsViewController.h"
#import "ZZUtility.h"
#import "RSKImageCropViewController.h"
#import "SVProgressHUD.h"
#import "EGOCache.h"

@interface ZZMeViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate>

@property (strong, nonatomic) UIImageView* avatar;
@property (strong, nonatomic) UILabel* username;

@end

static float const kMeAvatarToTop = 69/2.0f;
static float const kMeAvatarSize = 285/2.0f;

static float const kMeNameToTop = kMeAvatarToTop + kMeAvatarSize + 45/2.0f;
static float const kMeNameWidth = 200;
static float const kMeNameHeight = 25;
static float const kMeNameFontSize = 22;

static float const kMeLabelsToLeft5 = 50/2.0f;
static float const kMeLabelsWidth5 = 180;
static float const kMeLabelsHeight5 = 30;
static float const kMeLabelsFontSize5 = 14;
static float const kMeLabelsMargin5 = 6;
static float const kMeLineToText5 = 26;
static float const kMeLineHeight5 = 0.5;

@implementation ZZMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"Home"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    // draw avatar background
//    UIImageView* avatarBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake((([ZZUtility getScreenWidth]-102)/2.0f), 25-1, 102, 102)];
//    avatarBackgroundImageView.layer.masksToBounds = YES;
//    avatarBackgroundImageView.layer.cornerRadius = avatarBackgroundImageView.frame.size.height/2;
//    avatarBackgroundImageView.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:avatarBackgroundImageView];
    
    // draw avatar
    self.avatar = [[UIImageView alloc] initWithFrame:CGRectMake(([ZZUtility getScreenWidth]-kMeAvatarSize)/2.0f, kMeAvatarToTop, kMeAvatarSize, kMeAvatarSize)];
    self.avatar.layer.masksToBounds = YES;
    self.avatar.layer.cornerRadius = self.avatar.frame.size.height/2;
    //self.avatar.layer.borderWidth = 2.0f;
    self.avatar.userInteractionEnabled = YES;
    //self.avatar.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:self.avatar];
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editAvatar)];
    avatarTap.numberOfTapsRequired = 1;
    [self.avatar addGestureRecognizer:avatarTap];
    
    // draw label, showing username
    self.username = [[UILabel alloc] initWithFrame:CGRectMake(([ZZUtility getScreenWidth]-kMeNameWidth)/2.0f, kMeNameToTop, kMeNameWidth, kMeNameHeight)];
    self.username.textAlignment = NSTextAlignmentCenter;
    self.username.font = [UIFont fontWithName:@"Copperplate-Light" size:kMeNameFontSize];
    self.username.textColor = [UIColor blackColor];
    [self.view addSubview:self.username];
    
    // draw show friends, add friends, friend requests, settings
    UIFont *menuFont = [UIFont fontWithName:@"Copperplate-Light" size:kMeLabelsFontSize5];
    
    CGFloat labelsToNameDistance = [ZZUtility getScreenHeight]-kMeNameToTop-kMeNameHeight-(4*kMeLabelsHeight5)-(3*kMeLabelsMargin5)-self.tabBarController.tabBar.frame.size.height-self.navigationController.navigationBar.frame.size.height;
    labelsToNameDistance /= 2;
    labelsToNameDistance -=8;
    //NSLog(@"%f", labelsToNameDistance);
    
    CGFloat kMeShowFriendsToTop5 = kMeNameToTop + kMeNameHeight + labelsToNameDistance;
    CGFloat kMeAddFriendsToTop5 = kMeShowFriendsToTop5 + kMeLabelsHeight5 +kMeLabelsMargin5;
    CGFloat kMeFriendRequestsToTop5 = kMeAddFriendsToTop5 + kMeLabelsHeight5 +kMeLabelsMargin5;
    CGFloat kMeSettingsToTop5 = kMeFriendRequestsToTop5 + kMeLabelsHeight5 +kMeLabelsMargin5;
    
    // show friends
    CGRect showFriendsFrame = CGRectMake(kMeLabelsToLeft5, kMeShowFriendsToTop5, kMeLabelsWidth5, kMeLabelsHeight5);
    UILabel *showFriends = [[UILabel alloc] initWithFrame:showFriendsFrame];
    showFriends.font = menuFont;
    showFriends.textColor = [UIColor blackColor];
    showFriends.text = @"Show Friends";
    [self.view addSubview:showFriends];
    
    // add friends
    CGRect addFriendsFrame = CGRectMake(kMeLabelsToLeft5, kMeAddFriendsToTop5, kMeLabelsWidth5, kMeLabelsHeight5);
    UILabel *addFriends = [[UILabel alloc] initWithFrame:addFriendsFrame];
    addFriends.font = menuFont;
    addFriends.textColor = [UIColor blackColor];
    addFriends.text = @"Add Friends";
    [self.view addSubview:addFriends];
    
    // friend requests
    CGRect friendRequestsFrame = CGRectMake(kMeLabelsToLeft5, kMeFriendRequestsToTop5, kMeLabelsWidth5, kMeLabelsHeight5);
    UILabel *friendRequests = [[UILabel alloc] initWithFrame:friendRequestsFrame];
    friendRequests.font = menuFont;
    friendRequests.textColor = [UIColor blackColor];
    friendRequests.text = @"Friend Requests";
    [self.view addSubview:friendRequests];
    
    // settings
    CGRect settingsFrame = CGRectMake(kMeLabelsToLeft5, kMeSettingsToTop5, kMeLabelsWidth5, kMeLabelsHeight5);
    UILabel *settings = [[UILabel alloc] initWithFrame:settingsFrame];
    settings.font = menuFont;
    settings.textColor = [UIColor blackColor];
    settings.text = @"Settings";
    [self.view addSubview:settings];
    
    // draw lines
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(kMeLabelsToLeft5, kMeShowFriendsToTop5+kMeLineToText5, [ZZUtility getScreenWidth], kMeLineHeight5)];
    line1.backgroundColor = RGBACOLOR(0, 0, 0, 0.4);
    [self.view addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(kMeLabelsToLeft5, kMeAddFriendsToTop5+kMeLineToText5, [ZZUtility getScreenWidth], kMeLineHeight5)];
    line2.backgroundColor = RGBACOLOR(0, 0, 0, 0.4);
    [self.view addSubview:line2];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(kMeLabelsToLeft5, kMeFriendRequestsToTop5+kMeLineToText5, [ZZUtility getScreenWidth], kMeLineHeight5)];
    line3.backgroundColor = RGBACOLOR(0, 0, 0, 0.4);
    [self.view addSubview:line3];
    
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(kMeLabelsToLeft5, kMeSettingsToTop5+kMeLineToText5, [ZZUtility getScreenWidth], kMeLineHeight5)];
    line4.backgroundColor = RGBACOLOR(0, 0, 0, 0.4);
    [self.view addSubview:line4];
    
    // draw arrows
    UIImage *arrowImage = [UIImage imageNamed:@"MeArrow5.png"];
    CGFloat screenWidth = [ZZUtility getScreenWidth];
    
    UIImageView* arrow1 = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-18-7.5, kMeShowFriendsToTop5+10, 7.5, 9.5)];
    arrow1.image = arrowImage;
    [self.view addSubview:arrow1];
    
    UIImageView* arrow2 = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-18-7.5, kMeAddFriendsToTop5+10, 7.5, 9.5)];
    arrow2.image = arrowImage;
    [self.view addSubview:arrow2];
    
    UIImageView* arrow3 = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-18-7.5, kMeFriendRequestsToTop5+10, 7.5, 9.5)];
    arrow3.image = arrowImage;
    [self.view addSubview:arrow3];
    
    UIImageView* arrow4 = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-18-7.5, kMeSettingsToTop5+10, 7.5, 9.5)];
    arrow4.image = arrowImage;
    [self.view addSubview:arrow4];
    
    // draw buttons
    UIButton* button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, kMeShowFriendsToTop5, 320, kMeLineToText5)];
    [button1 addTarget:self action:@selector(pressShowFriends:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton* button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, kMeAddFriendsToTop5, 320, kMeLineToText5)];
    [button2 addTarget:self action:@selector(pressAddFriends:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton* button3 = [[UIButton alloc] initWithFrame:CGRectMake(0, kMeFriendRequestsToTop5, 320, kMeLineToText5)];
    [button3 addTarget:self action:@selector(pressFriendRequests:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    UIButton* button4 = [[UIButton alloc] initWithFrame:CGRectMake(0, kMeSettingsToTop5, 320, kMeLineToText5)];
    [button4 addTarget:self action:@selector(pressSettings:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
    
    if (![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {  // email
        if (![[EGOCache globalCache] hasCacheForKey:@"avatar"]) {
            NSLog(@"email login: no cached avatar, fetch from parse");
            [SVProgressHUD showWithStatus:@"Loading"];
            PFFile *avatarFile = [[PFUser currentUser] objectForKey:@"avatar"];
            [avatarFile getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
                if (!error) {
                    [SVProgressHUD dismiss];
                    self.avatar.image = [UIImage imageWithData:result];
                    [[EGOCache globalCache] setImage:[UIImage imageWithData:result] forKey:@"avatar"];
                }
            }];
        }
        else {
            self.avatar.image = [[EGOCache globalCache] imageForKey:@"avatar"];
            NSLog(@"email login: load cached avatar");
        }
        self.username.text = [PFUser currentUser].username;
    }
    else { // facebook
        if ([[EGOCache globalCache] hasCacheForKey:@"avatar"] && [PFUser currentUser].email != nil) { // use cached data
            self.username.text = [PFUser currentUser].username;
            self.avatar.image = [[EGOCache globalCache] imageForKey:@"avatar"];
            NSLog(@"facebook login: load cached username and avatar");
        }
        else { // otherwise fetch from Facebook
            if (![PFUser currentUser].isNew) {
                NSLog(@"facebook login: not new, no cached username and avatar, fetch from parse");
                [SVProgressHUD showWithStatus:@"Loading"];
                self.username.text = [PFUser currentUser].username;
                PFFile* avatarFile = [[PFUser currentUser] objectForKey:@"avatar"];
                [avatarFile getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
                    if (!error) {
                        [SVProgressHUD dismiss];
                        self.avatar.image = [UIImage imageWithData:result];
                        [[EGOCache globalCache] setImage:[UIImage imageWithData:result] forKey:@"avatar"];
                    }
                }];
            }
        }
    }
}

- (void)editAvatar {
    UIActionSheet* choosePhotoSourceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                        delegate:self
                                                               cancelButtonTitle:@"Cancel"
                                                          destructiveButtonTitle:nil
                                                               otherButtonTitles:@"Take a new photo", @"Choose from existing", nil];
    [choosePhotoSourceSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // take a photo
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller animated:YES completion:nil];
        }
        
    } else if (buttonIndex == 1) {
        // choose from existing
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller animated:YES completion:nil];
        }
    }
}

#pragma mark imagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *selectedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:selectedImage];
    imageCropVC.delegate = self;
    //imageCropVC.hidesBottomBarWhenPushed = YES;
    [picker presentViewController:imageCropVC animated:YES completion:nil];
}

#pragma mark RSKImageCropViewController delegate

// Crop image has been canceled.
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

// The original image has been cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect {
    PFFile* avatarFile = [PFFile fileWithData:UIImageJPEGRepresentation(croppedImage, 0.5f)];
    [[PFUser currentUser] setObject:avatarFile forKey:@"avatar"];
    [[PFUser currentUser] saveInBackground];
    [[EGOCache globalCache] setImage:croppedImage forKey:@"avatar"];
    self.avatar.image = croppedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark camera utility

- (BOOL) isCameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable {
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary {
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary {
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType {
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

- (void)pressShowFriends:(id)sender {
    UIViewController* contactsVC = [[ZZContactsViewController alloc] init];
    contactsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:contactsVC animated:YES];
}

- (void)pressAddFriends:(id)sender {
    UIViewController* addFriendVC = [[ZZAddFriendViewController alloc] init];
    addFriendVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addFriendVC animated:YES];
}

- (void)pressFriendRequests:(id)sender {
    UIViewController* confirmFriendVC = [[ZZAcceptFriendsViewController alloc] init];
    confirmFriendVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:confirmFriendVC animated:YES];
}

- (void)pressSettings:(id)sender {
    UIViewController* settingsViewController = [[ZZSettingsViewController alloc] init];
    settingsViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

@end
