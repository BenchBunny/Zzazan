//
//  ZZActivityDetailViewController.m
//  Zzazan
//
//  Created by Frank_Liu on 4/13/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import "ZZActivityDetailViewController.h"
#import "ZZActivityCell.h"
#import <Firebase/Firebase.h>
#import <Parse/Parse.h>

@interface ZZActivityDetailViewController ()

@end

@implementation ZZActivityDetailViewController
@synthesize activity;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 80;
    NSString *username = [[PFUser currentUser] objectForKey:@"username"];
    
    Firebase *ref = [[Firebase alloc] initWithUrl: @"https://vivid-torch-7789.firebaseio.com/"];
    
    Firebase *alanRef = [ref childByAppendingPath: [NSString stringWithFormat:@"activitySignal/%@", username]];
    [alanRef removeValue];
    
    self.activityList = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"MatchedActivity"];
    [query whereKey:@"user1" equalTo:[[PFUser currentUser] objectForKey:@"username"]];
    [query orderByDescending: @"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *result, NSError *error) {
        [self.activityList removeAllObjects];
        for (PFObject *i in result){
            if ([[i objectForKey:@"activity"] isEqualToString:self.activity]){
                if ([[i objectForKey:@"hiddenState"] isEqual:@"NO"]){
                    [self.activityList addObject:i];
                }
            }
        }
        [self.tableView reloadData];
    }];
    
    [alanRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        if ([snapshot.value[@"reload"] isEqual:@"YES"]){
            PFQuery *query = [PFQuery queryWithClassName:@"MatchedActivity"];
            [query whereKey:@"user1" equalTo:[[PFUser currentUser] objectForKey:@"username"]];
            [query orderByDescending: @"createdAt"];
            [query findObjectsInBackgroundWithBlock:^(NSArray *result, NSError *error) {
                [self.activityList removeAllObjects];
                for (PFObject *i in result){
                    if ([[i objectForKey:@"activity"] isEqualToString:self.activity]){
                        if ([[i objectForKey:@"hiddenState"] isEqual:@"NO"]){
                            [self.activityList addObject:i];
                        }
                    }
                }
                [self.tableView reloadData];
            }];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.activityList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZActivityCell *cell = (ZZActivityCell *)[tableView dequeueReusableCellWithIdentifier:@"detailed"];
    
    NSString *name = [[self.activityList objectAtIndex:indexPath.row] objectForKey:@"user2"];
    NSString *date = [[self.activityList objectAtIndex:indexPath.row] objectForKey:@"date"];
    NSArray *seperate = [date componentsSeparatedByString:@" "];
    NSArray *seperate2 = [date componentsSeparatedByString:@"-"];

    
    ZZFeedPost *nonePost = [[ZZFeedPost alloc]
                            initWithName:name
                            AvatarURL:@""
                            Activity:@""
                            NumberOfLikes:0
                            Date:[NSString stringWithFormat:@"%@-%@ %@", [seperate2 objectAtIndex:0], [seperate2 objectAtIndex:1], [seperate objectAtIndex:1]]
                            ObjectId:@""];
    
    cell = [[ZZActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailed" postModel:nonePost];
    return cell;
}

@end
