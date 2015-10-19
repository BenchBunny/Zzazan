//
//  ZZActivitiesViewController.m
//  Zzazan
//
//  Created by Yiming Jiang on 4/12/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import "ZZActivitiesViewController.h"
#import "ZZActivities.h"
#import "ZZActivitiesSelectFriendsViewController.h"
#import <Parse/Parse.h>
#import <Firebase/Firebase.h>

@interface ZZActivitiesViewController ()

@end

@implementation ZZActivitiesViewController {
    NSMutableArray *dataModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Activities"];
    
    dataModel = [NSMutableArray array];
    
    PFObject *currentUser = [PFUser currentUser];
    if ([[currentUser objectForKey:@"activity1"] isEqualToString:@"YES"])
        [dataModel addObject:[[ZZActivities alloc] initWithActivity:@"Gym" state:YES]];
    else
        [dataModel addObject:[[ZZActivities alloc] initWithActivity:@"Gym" state:NO]];
    
    if ([[currentUser objectForKey:@"activity2"] isEqualToString:@"YES"])
        [dataModel addObject:[[ZZActivities alloc] initWithActivity:@"Coffee" state:YES]];
    else
        [dataModel addObject:[[ZZActivities alloc] initWithActivity:@"Coffee" state:NO]];
    
    if ([[currentUser objectForKey:@"activity3"] isEqualToString:@"YES"])
        [dataModel addObject:[[ZZActivities alloc] initWithActivity:@"Eat" state:YES]];
    else
        [dataModel addObject:[[ZZActivities alloc] initWithActivity:@"Eat" state:NO]];
    
    if ([[currentUser objectForKey:@"activity4"] isEqualToString:@"YES"])
        [dataModel addObject:[[ZZActivities alloc] initWithActivity:@"Study" state:YES]];
    else
        [dataModel addObject:[[ZZActivities alloc] initWithActivity:@"Study" state:NO]];
    
    if ([[currentUser objectForKey:@"activity5"] isEqualToString:@"YES"])
        [dataModel addObject:[[ZZActivities alloc] initWithActivity:@"Movie" state:YES]];
    else
        [dataModel addObject:[[ZZActivities alloc] initWithActivity:@"Movie" state:NO]];

    if ([[currentUser objectForKey:@"activity6"] isEqualToString:@"YES"])
        [dataModel addObject:[[ZZActivities alloc] initWithActivity:@"Shopping" state:YES]];
    else
        [dataModel addObject:[[ZZActivities alloc] initWithActivity:@"Shopping" state:NO]];
    
    if ([[currentUser objectForKey:@"activity7"] isEqualToString:@"YES"])
        [dataModel addObject:[[ZZActivities alloc] initWithActivity:@"Anything" state:YES]];
    else
        [dataModel addObject:[[ZZActivities alloc] initWithActivity:@"Anything" state:NO]];



    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.tableView.allowsSelection = NO;
    // Associate the device with a user
    PFInstallation *installation = [PFInstallation currentInstallation];
    installation[@"user"] = [PFUser currentUser];
    [installation saveInBackground];
    
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataModel.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 176/2.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    ZZActivitiesTableViewCell *cell = (ZZActivitiesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    //
    //    if (!cell) {
    ZZActivitiesTableViewCell *cell = [[ZZActivitiesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                       reuseIdentifier:@"cellIdentifier"
                                                                                 model:dataModel[indexPath.row]];
    //}
    
    cell.delegate = self;
    cell.cellIndex = indexPath.row;
    
    return cell;
}

#pragma mark - Action Receiver

- (void)didClickOnCellAtIndex:(NSInteger)cellIndex withCommand:(NSString *)command {
    NSString *status;
    NSString *username = [[PFUser currentUser] objectForKey:@"username"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellIndex inSection:0];
    NSString *activityName = [NSString stringWithFormat:@"activity%zd", indexPath.row + 1];
    
    ZZActivities *activities = dataModel[indexPath.row];
    if ([command isEqualToString:@"turn_on_activity"]) {
        //NSLog(@"turn on activity @ %ld", indexPath.row);
        activities.isOn = !activities.isOn;
        if (activities.isOn){
            //NSLog(@"YES");
            //NSLog(@"switch is on, of index %ld, %@", switcher.tag, activityName);
            NSString *activitiesName;
            if (indexPath.row == 0) {
                activitiesName = @"Gym";
            }
            else if (indexPath.row == 1) {
                activitiesName = @"Coffee";
            }
            else if (indexPath.row == 2) {
                activitiesName = @"Eat";
            }
            else if (indexPath.row == 3) {
                activitiesName = @"Study";
            }
            else if (indexPath.row == 4){
                activitiesName = @"Movie";
            }
            else if (indexPath.row == 5){
                activitiesName = @"Shopping";
            }
            else if (indexPath.row == 6){
                activitiesName = @"Anything";
            }
            PFObject *turnOnTime = [PFObject objectWithClassName:@"TurnOnTime"];
            turnOnTime[@"user_name"] = [PFUser currentUser].username;
            turnOnTime[@"activity_name"] = activitiesName;
            turnOnTime[@"number_of_likes"] = @0;
            [turnOnTime saveInBackground];
            
            status = @"YES";
            PFQuery *query = [PFQuery queryWithClassName:@"MatchedActivity"];
            [query whereKey:@"user1" equalTo:username];
            [query findObjectsInBackgroundWithBlock:^(NSArray *result, NSError *error) {
                for (PFObject *i in result){
                    NSString *number = [i objectForKey:@"activity"];
                    if ([number isEqual:[NSString stringWithFormat:@"%zd", indexPath.row + 1]]){
                        [i setObject:@"NO" forKey:@"hiddenState"];
                        [i saveInBackground];
                    }
                }
            }];
            
            
            NSDictionary *signal = @{
                                     @"reload" : @"YES"
                                     //@"message": @"June 23, 1912"
                                     };
            
            
            PFQuery *query2 = [PFQuery queryWithClassName:@"MatchedActivity"];
            [query2 whereKey:@"user2" equalTo:username];
            [query2 findObjectsInBackgroundWithBlock:^(NSArray *result2, NSError *error) {
                for (PFObject *i in result2){
                    NSString *number = [i objectForKey:@"activity"];
                    if ([number isEqual:[NSString stringWithFormat:@"%zd", indexPath.row + 1]]){
                        [i setObject:@"NO" forKey:@"hiddenState"];
                        [i saveInBackground];
                        Firebase *ref = [[Firebase alloc] initWithUrl: @"https://vivid-torch-7789.firebaseio.com/"];
                        Firebase *alanRef = [ref childByAppendingPath: [NSString stringWithFormat:@"activitySignal/%@", [i objectForKey:@"user1"]]];
                        Firebase *alanRef1 = [ref childByAppendingPath: [NSString stringWithFormat:@"activitySignal/%@", [i objectForKey:@"user2"]]];
                        
                        [[alanRef childByAutoId] setValue:signal];
                        [[alanRef1 childByAutoId] setValue:signal];
                    }
                }
            }];
            
        }
        if (!activities.isOn){
            status = @"NO";
            PFQuery *query = [PFQuery queryWithClassName:@"MatchedActivity"];
            [query whereKey:@"user1" equalTo:username];
            [query findObjectsInBackgroundWithBlock:^(NSArray *result, NSError *error) {
                for (PFObject *i in result){
                    NSString *number = [i objectForKey:@"activity"];
                    if ([number isEqual:[NSString stringWithFormat:@"%zd", indexPath.row + 1]]){
                        [i setObject:@"YES" forKey:@"hiddenState"];
                        [i saveInBackground];
                    }
                }
            }];
            
            
            NSDictionary *signal = @{
                                     @"reload" : @"YES"
                                     //@"message": @"June 23, 1912"
                                     };
            
            
            PFQuery *query2 = [PFQuery queryWithClassName:@"MatchedActivity"];
            [query2 whereKey:@"user2" equalTo:username];
            [query2 findObjectsInBackgroundWithBlock:^(NSArray *result2, NSError *error) {
                for (PFObject *i in result2){
                    NSString *number = [i objectForKey:@"activity"];
                    if ([number isEqual:[NSString stringWithFormat:@"%zd", indexPath.row + 1]]){
                        [i setObject:@"YES" forKey:@"hiddenState"];
                        [i saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (succeeded){
                                Firebase *ref = [[Firebase alloc] initWithUrl: @"https://vivid-torch-7789.firebaseio.com/"];
                                Firebase *alanRef = [ref childByAppendingPath: [NSString stringWithFormat:@"activitySignal/%@", [i objectForKey:@"user1"]]];
                                Firebase *alanRef1 = [ref childByAppendingPath: [NSString stringWithFormat:@"activitySignal/%@", [i objectForKey:@"user2"]]];
                                
                                [[alanRef childByAutoId] setValue:signal];
                                [[alanRef1 childByAutoId] setValue:signal];
                            }
                        }];
                    }
                }
            }];
            
        }
        PFUser *currentUser = [PFUser currentUser];
        [currentUser setObject:status forKey:activityName];
        [currentUser saveInBackground];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if ([command isEqualToString:@"select_friends"]) {
        //NSLog(@"select friends @ %ld", indexPath.row);
        ZZActivitiesSelectFriendsViewController *selectVC = [[ZZActivitiesSelectFriendsViewController alloc] init];
        selectVC.selectedActivity = (NSInteger *)(indexPath.row + 1);
        selectVC.navigationItem.title = activities.activity;
        [self.navigationController pushViewController:selectVC animated:YES];
    }
}


@end
