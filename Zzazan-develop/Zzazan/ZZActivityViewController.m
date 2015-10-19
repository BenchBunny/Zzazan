//
//  ZZActivityViewController.m
//  Zzazan
//
//  Created by Yiming Jiang on 2/10/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import "ZZActivityViewController.h"
#import "SwipeView.h"
#import "ZZUtility.h"
#import "ZZAcceptFriendsTableViewCell.h"
#import <Firebase/Firebase.h>
#import "ZZActivityCell.h"
#import "ZZFeedTableViewCell.h"
#import "ZZActivityDetailViewController.h"


#define NUMBER_OF_VIEWS 2

@interface ZZActivityViewController () <SwipeViewDataSource, SwipeViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SwipeView *swipeView;
@property (nonatomic, strong) UIButton *timeButton;
@property (nonatomic, strong) UIButton *typeButton;

@end
NSArray *realActivity;
BOOL flag = YES;

@implementation ZZActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Matches"];
    // Do any additional setup after loading the view from its nib.
    realActivity = [NSArray arrayWithObjects:@"Gym", @"Coffee",@"Eat", @"Study",@"Movie",@"Shopping",@"Anything",nil];
    
    
    CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    CGFloat buttonHeight = 50;
    CGFloat buttonWidth = [ZZUtility getScreenWidth]/2.0f;
    
    CGFloat swipeViewHeight = [ZZUtility getScreenHeight]-statusHeight-navBarHeight-tabBarHeight-buttonHeight;
    
    CGRect swipeViewRect = CGRectMake(0,buttonHeight, [ZZUtility getScreenWidth], swipeViewHeight);
    self.swipeView = [[SwipeView alloc] initWithFrame:swipeViewRect];
    
    self.swipeView.delegate = self;
    self.swipeView.dataSource = self;
    
    self.swipeView.pagingEnabled = YES;
    
    [self.view addSubview:self.swipeView];
    
    // draw buttons
    self.timeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, buttonHeight)];
    self.typeButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonWidth, 0, buttonWidth, buttonHeight)];
    
    self.timeButton.backgroundColor = [UIColor whiteColor];
    self.typeButton.backgroundColor = [UIColor whiteColor];
    
    UIFont* buttonFont = [UIFont fontWithName:@"Copperplate-Light" size:18];
    //UIFont* buttonFont = [UIFont systemFontOfSize:18];
    
    [self.timeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"TIME" attributes:@{NSFontAttributeName: buttonFont, NSForegroundColorAttributeName: RGBACOLOR(240, 91, 114, 1.0)}] forState:UIControlStateNormal];
    
    [self.typeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"ACTIVITY" attributes:@{NSFontAttributeName: buttonFont, NSForegroundColorAttributeName: [UIColor blackColor]}] forState:UIControlStateNormal];
    
    [self.timeButton addTarget:self action:@selector(timeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.typeButton addTarget:self action:@selector(typeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.timeButton];
    [self.view addSubview:self.typeButton];
    
    // draw vertical line
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(buttonWidth,15,0.5, 20)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:lineView];
    
    // draw horizontal line
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, buttonHeight, [ZZUtility getScreenWidth], 0.5)];
    horizontalLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:horizontalLine];
    
    self.activitylist = [[NSMutableArray alloc] init];
    self.activityInUse = [[NSMutableArray alloc] init];
    self.activityInUseDetail = [[NSMutableArray alloc] init];
   
    NSString *username = [[PFUser currentUser] objectForKey:@"username"];
    
    Firebase *ref = [[Firebase alloc] initWithUrl: @"https://vivid-torch-7789.firebaseio.com/"];
    
    Firebase *alanRef = [ref childByAppendingPath: [NSString stringWithFormat:@"activitySignal/%@", username]];

    [alanRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        if ([snapshot.value[@"reload"] isEqual:@"YES"]){
            PFQuery *query = [PFQuery queryWithClassName:@"MatchedActivity"];
            [query whereKey:@"user1" equalTo:[[PFUser currentUser] objectForKey:@"username"]];
            [query orderByDescending: @"createdAt"];
            [query findObjectsInBackgroundWithBlock:^(NSArray *result, NSError *error) {
                [self.activitylist removeAllObjects];
                [self.activityInUse removeAllObjects];
                [self.activityInUseDetail removeAllObjects];
                [self.activitylist removeAllObjects];
                for (PFObject *i in result){
                    if ([[i objectForKey:@"hiddenState"] isEqual:@"NO"]){
                        [self.activitylist addObject:i];
                        NSString *activityType = [i objectForKey:@"activity"];
                        if (![self.activityInUse containsObject:activityType]){
                            [self.activityInUse addObject:activityType];
                            [self.activityInUseDetail addObject:i];
                        }
                    }
                }
                [self.swipeView reloadData];
            }];
        }
        [alanRef removeValue];

    }];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"MatchedActivity"];
    
    [query whereKey:@"user1" equalTo:[[PFUser currentUser] objectForKey:@"username"]];
    [query orderByDescending: @"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *result, NSError *error) {
        [self.activitylist removeAllObjects];
        [self.activityInUse removeAllObjects];
        [self.activityInUseDetail removeAllObjects];
        for (PFObject *i in result){
            if ([[i objectForKey:@"hiddenState"] isEqual:@"NO"]){
                [self.activitylist addObject:i];
                NSString *activityType = [i objectForKey:@"activity"];
                if (![self.activityInUse containsObject:activityType]){
                    [self.activityInUse addObject:activityType];
                    [self.activityInUseDetail addObject:i];
                }
            }
        }
        [self.swipeView reloadData];
    }];

    
}

- (void)timeButtonPressed:(id)sender {
    [self.swipeView scrollToItemAtIndex:0 duration:0.5];
}

- (void)typeButtonPressed:(id)sender {
    [self.swipeView scrollToItemAtIndex:1 duration:0.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    //return the total number of items in the carousel
    return NUMBER_OF_VIEWS;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    
    //NSLog(@"I am now at index %ld", index);
    
    UITableView *tbview = (UITableView *)view;
    //create new view if no view is available for recycling
    if (tbview == nil) {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        tbview = [[UITableView alloc] initWithFrame:self.swipeView.bounds style:UITableViewStylePlain];
        tbview.delegate = self;
        tbview.dataSource = self;
        //tbview.tag = index;
        //NSLog(@"view is nil");
    }
    else {
        //get a reference to the label in the recycled view
        //NSLog(@"view is not nil");
        if (tbview.tag != index) {
            tbview = [[UITableView alloc] initWithFrame:self.swipeView.bounds style:UITableViewStylePlain];
            tbview.delegate = self;
            tbview.dataSource = self;
        }
    }
    
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    tbview.tag = index;
    tbview.tableFooterView = [[UIView alloc] init];
    return tbview;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView {
    return self.swipeView.bounds.size;
}

- (void)swipeViewDidEndDecelerating:(SwipeView *)swipeView {
    //NSLog(@"current index: %ld", swipeView.currentPage);
    //UIFont* buttonFont = [UIFont systemFontOfSize:18];
    UIFont* buttonFont = [UIFont fontWithName:@"Copperplate-Light" size:18];
    if (swipeView.currentPage %2 == 0) {
        [self.timeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"TIME" attributes:@{NSFontAttributeName: buttonFont, NSForegroundColorAttributeName: RGBACOLOR(240, 91, 114, 1.0)}] forState:UIControlStateNormal];
        
        [self.typeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"ACTIVITY" attributes:@{NSFontAttributeName: buttonFont, NSForegroundColorAttributeName: [UIColor blackColor]}] forState:UIControlStateNormal];
    }
    else {
        [self.timeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"TIME" attributes:@{NSFontAttributeName: buttonFont, NSForegroundColorAttributeName: [UIColor blackColor]}] forState:UIControlStateNormal];
        
        [self.typeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"ACTIVITY" attributes:@{NSFontAttributeName: buttonFont, NSForegroundColorAttributeName: RGBACOLOR(240, 91, 114, 1.0)}] forState:UIControlStateNormal];
    }
}

- (void)swipeViewDidEndScrollingAnimation:(SwipeView *)swipeView {
    //UIFont* buttonFont = [UIFont systemFontOfSize:18];
    UIFont* buttonFont = [UIFont fontWithName:@"Copperplate-Light" size:18];
    if (swipeView.currentPage %2 == 0) {
        [self.timeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"TIME" attributes:@{NSFontAttributeName: buttonFont, NSForegroundColorAttributeName: RGBACOLOR(240, 91, 114, 1.0)}] forState:UIControlStateNormal];
        
        [self.typeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"ACTIVITY" attributes:@{NSFontAttributeName: buttonFont, NSForegroundColorAttributeName: [UIColor blackColor]}] forState:UIControlStateNormal];
    }
    else {
        [self.timeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"TIME" attributes:@{NSFontAttributeName: buttonFont, NSForegroundColorAttributeName: [UIColor blackColor]}] forState:UIControlStateNormal];
        
        [self.typeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"ACTIVITY" attributes:@{NSFontAttributeName: buttonFont, NSForegroundColorAttributeName: RGBACOLOR(240, 91, 114, 1.0)}] forState:UIControlStateNormal];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == 0){
        return [self.activitylist count];
    }
    return [self.activityInUse count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.rowHeight = 80;
    
    
    static NSString *identifier = @"Cell";
    ZZActivityCell *cell = (ZZActivityCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    //UIImage *image = [UIImage imageNamed:@"UserAvatarDemo.png"];
    if (tableView.tag == 0){
        NSString *number = [[self.activitylist objectAtIndex:indexPath.row] objectForKey:@"activity"];
        NSString *name = [[self.activitylist objectAtIndex:indexPath.row] objectForKey:@"user2"];
        NSString *date = [[self.activitylist objectAtIndex:indexPath.row] objectForKey:@"date"];
        NSArray *seperate = [date componentsSeparatedByString:@" "];
        NSArray *seperate2 = [date componentsSeparatedByString:@"-"];
        number = [realActivity objectAtIndex:[number intValue] - 1];
        ZZFeedPost *nonePost = [[ZZFeedPost alloc]
                                initWithName:name
                                AvatarURL:@""
                                Activity:number
                                NumberOfLikes:0
                                Date:[NSString stringWithFormat:@"%@-%@ %@", [seperate2 objectAtIndex:0], [seperate2 objectAtIndex:1], [seperate objectAtIndex:1]]
                                ObjectId:@""];
        
        cell = [[ZZActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier postModel:nonePost];
        
    }
    if (tableView.tag == 1){
        NSString *typeNumber = [self.activityInUse objectAtIndex:indexPath.row];
        NSString *name;
        NSString *date = [[self.activityInUseDetail objectAtIndex:indexPath.row] objectForKey:@"date"];
        NSArray *seperate = [date componentsSeparatedByString:@" "];
        NSArray *seperate2 = [date componentsSeparatedByString:@"-"];
        
        if ([typeNumber isEqualToString:@"1"]){
            name = @"Gym";
        }
        if ([typeNumber isEqualToString:@"2"]){
            name = @"Coffee";
        }
        if ([typeNumber isEqualToString:@"3"]){
            name = @"Eat";
        }
        if ([typeNumber isEqualToString:@"4"]){
            name = @"Study";
        }
        if ([typeNumber isEqualToString:@"5"])
        {
            name = @"Movie";
        }
        if ([typeNumber isEqualToString:@"6"])
        {
            name = @"Shopping";
        }
        if ([typeNumber isEqualToString:@"7"])
        {
            name = @"Anything";
        }
        
        
        ZZFeedPost *nonePost = [[ZZFeedPost alloc]
                                initWithName:name
                                AvatarURL:@""
                                Activity:@""
                                NumberOfLikes:0
                                Date:[NSString stringWithFormat:@"%@-%@ %@", [seperate2 objectAtIndex:0], [seperate2 objectAtIndex:1], [seperate objectAtIndex:1]]
                                ObjectId:@""];
        
        cell = [[ZZActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier postModel:nonePost];
        
    }
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    if (tableView.tag == 1){
        ZZActivityDetailViewController *detail = [[ZZActivityDetailViewController alloc] init];
        detail.activity = [self.activityInUse objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detail animated:YES];
    }
}

@end
