//
//  ZZActivitiesSelectFriendsViewController.m
//  Zzazan
//
//  Created by Yiming Jiang on 4/13/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import "ZZActivitiesSelectFriendsViewController.h"
#import <Firebase/Firebase.h>
#import <Parse/Parse.h>
#import "ZZActivitiesViewController.h"

@interface ZZActivitiesSelectFriendsViewController ()

@property (strong, nonatomic) NSMutableArray *dataModel;

@end

NSMutableArray *friendList;
NSMutableArray *addList;
NSString *tagetAvtivity;
NSString *activityState;
BOOL state;



@implementation ZZActivitiesSelectFriendsViewController
@synthesize selectedActivity;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.allowsSelection = NO;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.dataModel = [NSMutableArray array];
    UIImage *image = [UIImage imageNamed:@"UserAvatarDemo.png"];
    
    addList = [[NSMutableArray alloc] init];
    friendList = [[NSMutableArray alloc] init];
    tagetAvtivity = [NSString stringWithFormat:@"Activity%zdMember", self.selectedActivity];
    activityState = [NSString stringWithFormat:@"activity%zd", self.selectedActivity];
    PFUser *currentUser = [PFUser currentUser];
    addList = [currentUser objectForKey:tagetAvtivity];
    if (addList == NULL){
        addList = [[NSMutableArray alloc] init];
        
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"FriendRelation"];
    NSString *currentName = [currentUser objectForKey:@"username"];
    [query whereKey:@"Username" equalTo:currentName];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        NSArray *result = [object objectForKey:@"friendList"];
        for (NSString *friendname in result){
            PFQuery *query1 = [PFUser query];
            [query1 whereKey:@"username" equalTo:friendname];
            [query1 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                NSString *status = [object objectForKey:activityState];
                if ([status isEqual:@"YES"]){
                    if ([addList containsObject:friendname])
                        state = YES;
                    else
                        state = NO;
                    ZZActivitiesSelectFriends *entry = [[ZZActivitiesSelectFriends alloc] initWithAvatar:image name: friendname  state:state];
                    [self.dataModel addObject:entry];
                    [self.tableView reloadData];
                }
            }];
        }
    }];
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
        [cell setLayoutMargins:UIEdgeInsetsMake(0.0, 80.0, 0.0, 0.0)];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataModel.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 133/2.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZActivitiesSelectFriendsTableViewCell *cell = [[ZZActivitiesSelectFriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier" model:self.dataModel[indexPath.row]];
    
    cell.delegate = self;
    cell.cellIndex = indexPath.row;
    
    return cell;
}

#pragma mark - Action Receiver

- (void)didClickOnCellAtIndex:(NSInteger)cellIndex withCommand:(NSString *)command {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellIndex inSection:0];
    ZZActivitiesSelectFriends *entry = self.dataModel[indexPath.row];
    if ([command isEqualToString:@"select_a_friend"]) {
        entry.isSelected = !entry.isSelected;
        if (!entry.isSelected){
            NSString *deletedname = entry.name;
            PFQuery *query = [PFQuery queryWithClassName:@"ActivityState"];
            [query whereKey:@"username" equalTo:[[PFUser currentUser] objectForKey:@"username"]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                for (PFObject *i in objects){
                    NSString *a = [i objectForKey:@"receiver"];
                    NSString *b = [i objectForKey:@"activity"];
                    if ([a isEqualToString:deletedname] && [b isEqualToString:[NSString stringWithFormat:@"%zd", self.selectedActivity]]){
                        [i deleteInBackground];
                    }
                }
            }];
            
            PFQuery *query1 = [PFQuery queryWithClassName:@"MatchedActivity"];
            [query1 whereKey:@"user1" equalTo:[[PFUser currentUser] objectForKey:@"username"]];
            [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                NSString *ru, *ra;
                for (PFObject *i in objects){
                    ru = [i objectForKey:@"user2"];
                    ra = [i objectForKey:@"activity"];
                    if ([ru isEqualToString:deletedname] && [ra isEqualToString:[NSString stringWithFormat:@"%zd",self.selectedActivity]]){
                        [i deleteInBackground];
                        PFQuery *query2 = [PFQuery queryWithClassName:@"MatchedActivity"];
                        [query2 whereKey:@"user1" equalTo:ru];
                        [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects1, NSError *error) {
                            NSString *ruu, *raa;
                            for (PFObject *ii in objects1){
                                ruu = [ii objectForKey:@"user2"];
                                raa = [ii objectForKey:@"activity"];
                                if ([ruu isEqualToString:[[PFUser currentUser] objectForKey:@"username"]] && [raa isEqualToString:[NSString stringWithFormat:@"%zd",self.selectedActivity]]){
                                    [ii deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        Firebase *ref = [[Firebase alloc] initWithUrl: @"https://vivid-torch-7789.firebaseio.com/"];
                                        Firebase *alanRef = [ref childByAppendingPath: [NSString stringWithFormat:@"activitySignal/%@", ru]];
                                        NSDictionary *signal = @{
                                                                 @"reload" : @"YES"
                                                                 //@"message": @"June 23, 1912"
                                                                 };
                                        [[alanRef childByAutoId] setValue:signal];
                                        Firebase *alanRef1 = [ref childByAppendingPath: [NSString stringWithFormat:@"activitySignal/%@", ruu]];
                                        [[alanRef1 childByAutoId] setValue:signal];
                                        
                                    }];
                                    PFQuery *query4 = [PFQuery queryWithClassName:@"ActivityState"];
                                    [query4 whereKey:@"username" equalTo:ruu];
                                    [query4 findObjectsInBackgroundWithBlock:^(NSArray *objects6, NSError *error) {
                                        BOOL flag = YES;
                                        for (PFObject *iii in objects6){
                                            NSString *rru = [iii objectForKey:@"receiver"];
                                            NSString *acac = [iii objectForKey:@"activity"];
                                            if ([rru isEqualToString:ru] && [acac isEqualToString:[NSString stringWithFormat:@"%zd",self.selectedActivity]]){
                                                [iii deleteInBackground];
                                                flag = NO;
                                            }
                                        }
                                        NSLog(flag ? @"true" : @"false");
                                        if (flag){
                                            NSDate *today = [NSDate date];
                                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                            [dateFormatter setDateFormat:@"dd-MM-YYYY HH:mm"];
                                            NSString *currentTime = [dateFormatter stringFromDate:today];
                                            PFObject *requestForm = [PFObject objectWithClassName:@"ActivityState"];
                                            
                                            requestForm[@"username"] = ru;
                                            requestForm[@"receiver"] = ruu;
                                            requestForm[@"activity"] = [NSString stringWithFormat:@"%zd",self.selectedActivity];
                                            requestForm[@"date"] = currentTime;
                                            [requestForm saveEventually];
                                        }
                                    }];
                                }
                            }
                        }];
                        
                    }
                }
                [addList removeObject:deletedname];
                PFUser *currentUser = [PFUser currentUser];
                [currentUser setObject:addList forKey:tagetAvtivity];
                [currentUser saveInBackground];
            }];
        }
        if (entry.isSelected){
            NSString *currentUsername = [[PFUser currentUser] objectForKey:@"username"];
            for (ZZActivitiesSelectFriends *entry in self.dataModel){
                if (entry.isSelected){
                    NSString *username = entry.name;
                    if (![addList containsObject:username]){
                        [addList addObject:username];
                        PFQuery *acceptQuery = [PFQuery queryWithClassName:@"ActivityState"];
                        [acceptQuery whereKey:@"username" equalTo:username];
                        [acceptQuery findObjectsInBackgroundWithBlock:^(NSArray *receiverState, NSError *error) {
                            BOOL isShaked = NO;
                            PFQuery *userQuery = [PFUser query];
                            [userQuery whereKey:@"username" equalTo:username];
                            
                            // Find devices associated with these users
                            PFQuery *pushQuery = [PFInstallation query];
                            [pushQuery whereKey:@"user" matchesQuery:userQuery];
                            
                            // Send push notification to query
                            PFPush *push = [[PFPush alloc] init];
                            [push setQuery:pushQuery]; // Set our Installation query
                            NSDictionary *data1 = @{
                                                    @"alert": @"You got a match",
                                                    @"type": @"matched",
                                                    @"badge": @"increment"
                                                    };
                            for (PFObject *activityData in receiverState){
                                if ([[activityData objectForKey:@"receiver"] isEqual:currentUsername]){
                                    if ([[activityData objectForKey:@"activity"] isEqual:[NSString stringWithFormat:@"%zd",self.selectedActivity]]){
                                        isShaked = YES;
                                        // get current date/time
                                        NSDate *today = [NSDate date];
                                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                        // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
                                        [dateFormatter setDateFormat:@"dd-MM-YYYY HH:mm"];
                                        NSString *currentTime = [dateFormatter stringFromDate:today];
                                        
                                        PFObject *matchedPair1 = [PFObject objectWithClassName:@"MatchedActivity"];
                                        [matchedPair1 setObject:currentUsername forKey:@"user1"];
                                        [matchedPair1 setObject:username forKey:@"user2"];
                                        [matchedPair1 setObject:[NSString stringWithFormat:@"%zd", self.selectedActivity] forKey:@"activity"];
                                        [matchedPair1 setObject:@"NO" forKey:@"hiddenState"];
                                        [matchedPair1 setObject:currentTime forKey:@"date"];
                                        [matchedPair1 saveInBackground];
                                        
                                        PFObject *matchedPair2 = [PFObject objectWithClassName:@"MatchedActivity"];
                                        [matchedPair2 setObject:username forKey:@"user1"];
                                        [matchedPair2 setObject:currentUsername forKey:@"user2"];
                                        [matchedPair2 setObject:[NSString stringWithFormat:@"%zd", self.selectedActivity] forKey:@"activity"];
                                        [matchedPair2 setObject:@"NO" forKey:@"hiddenState"];
                                        [matchedPair2 setObject:currentTime forKey:@"date"];
                                        [matchedPair2 saveInBackground];
                                        [activityData deleteInBackground];
                                        
                                        Firebase *ref = [[Firebase alloc] initWithUrl: @"https://vivid-torch-7789.firebaseio.com/"];
                                        Firebase *alanRef = [ref childByAppendingPath: [NSString stringWithFormat:@"activitySignal/%@", username]];
                                        Firebase *alanRef1 = [ref childByAppendingPath: [NSString stringWithFormat:@"activitySignal/%@", currentUsername]];
                                        NSDictionary *signal = @{
                                                                 @"reload" : @"YES"
                                                                 //@"message": @"June 23, 1912"
                                                                 };
                                        [[alanRef childByAutoId] setValue:signal];
                                        [[alanRef1 childByAutoId] setValue:signal];
                                        [push setData:data1];
                                        [push sendPushInBackground];
                                        
                                         UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Matched"
                                             message:@"Congrudalation! You've got a date"
                                             delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles: nil];
//                                        [alert setTitle:@""];
                                        [alert show];
                                        
                                        
                                    }
                                }
                            }
                            if (!isShaked){
                                // get current date/time
                                NSDate *today = [NSDate date];
                                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
                                [dateFormatter setDateFormat:@"dd-MM-YYYY HH:mm"];
                                NSString *currentTime = [dateFormatter stringFromDate:today];
                                
                                PFObject *requestForm = [PFObject objectWithClassName:@"ActivityState"];
                                [requestForm setObject:currentUsername forKey:@"username"];
                                [requestForm setObject:username forKey:@"receiver"];
                                [requestForm setObject:[NSString stringWithFormat:@"%zd",self.selectedActivity] forKey:@"activity"];
                                [requestForm setObject:currentTime forKey:@"date"];
                                [requestForm saveInBackground];
                            }
                        }];
                    }
                    
                }
                
            }
            PFUser *currentUser = [PFUser currentUser];
            
            [currentUser setObject:addList forKey:tagetAvtivity];
            [currentUser saveInBackground];
            
        }
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end
