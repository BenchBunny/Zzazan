//
//  ZZContactsViewController.m
//  Zzazan
//
//  Created by Yiming Jiang on 2/14/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import "ZZContactsViewController.h"
#import "ZZAddFriendViewController.h"
#import "ZZAcceptFriendsViewController.h"
#import "ZZContactsTableViewCell.h"
#import "ZZChatView.h"
#import "ZZRequestButtonView.h"
#import <Parse/Parse.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <Firebase/Firebase.h>
#import "SVProgressHUD.h"

@interface ZZContactsViewController ()
@end

NSMutableArray *friendList;
NSMutableArray *avatarURLList;

@implementation ZZContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Contacts"];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.rowHeight = 60;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZZContactsTableViewCell" bundle:nil] forCellReuseIdentifier:@"ContactsCellIdentifier"];
    
    [SVProgressHUD showWithStatus:@"Connecting"];
    
    friendList = [[NSMutableArray alloc] init];
    avatarURLList = [NSMutableArray array];
    
    
    [PFCloud callFunctionInBackground:@"get_contact_avatar_url"
                       withParameters:@{}
                                block:^(id result, NSError *error) {
        if (!error) {
            NSArray *resultArray = (NSArray *)result;
            if (resultArray.count > 0) {
                for (NSDictionary *dict in resultArray) {
                    [friendList addObject:dict[@"name"]];
                    [avatarURLList addObject:dict[@"url"]];
                }
            }
            [SVProgressHUD dismiss];
            [self.tableView reloadData];
        }
    }];

    
    NSString *username = [[PFUser currentUser] objectForKey:@"username"];
    
    Firebase *ref = [[Firebase alloc] initWithUrl: @"https://vivid-torch-7789.firebaseio.com/"];
    
    Firebase *alanRef = [ref childByAppendingPath: [NSString stringWithFormat:@"FriendAccept/%@", username]];
    
    
    [alanRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        [PFCloud callFunctionInBackground:@"get_contact_avatar_url"
                           withParameters:@{}
                                    block:^(id result, NSError *error) {
                                        if (!error) {
                                            NSArray *resultArray = (NSArray *)result;
                                            [friendList removeAllObjects];
                                            [avatarURLList removeAllObjects];

                                            if (resultArray.count > 0) {
                                                for (NSDictionary *dict in resultArray) {
                                                    [friendList addObject:dict[@"name"]];
                                                    [avatarURLList addObject:dict[@"url"]];
                                                }
                                            }
                                            [SVProgressHUD dismiss];
                                            [self.tableView reloadData];
                                        }
                                    }];
        [alanRef removeValue];
        
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.definesPresentationContext = YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [friendList count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZContactsTableViewCell *cell = (ZZContactsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ContactsCellIdentifier" forIndexPath:indexPath];
    
    //    CGRect cellBounds = [[cell contentView] bounds];
    
    //cell.thumbnail.image = [UIImage imageNamed:@"UserAvatarDemo.png"];
    [cell.thumbnail sd_setImageWithURL: [NSURL URLWithString: [avatarURLList objectAtIndex:indexPath.row]]
                   placeholderImage: [UIImage imageNamed:@"AvatarPlaceHolder.png"]];
    cell.name.text = [friendList objectAtIndex:indexPath.row];
    
    return cell;
}

- (void) acceptButtonPressed:(id)sender {
    ZZRequestButtonView *currButton = (ZZRequestButtonView *)sender;
    [currButton removeFromSuperview];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZContactsTableViewCell* currCell = (ZZContactsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    ZZChatView *chat = [[ZZChatView alloc] init];
    for (UIView* view in currCell.contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* currButton = (UIButton *)view;
            [currButton setBackgroundColor:[UIColor colorWithRed:83.0f/255.0 green:179.0f/255.0 blue:16.0f/255.0 alpha:1.0]];
        }
    }
    chat.hidesBottomBarWhenPushed = YES;
    chat.senderName = currCell.name.text;
    [self.navigationController pushViewController:chat animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PFQuery *query = [PFQuery queryWithClassName:@"FriendRelation"];
        NSString *currentUsername = [[PFUser currentUser] objectForKey:@"username"];
        ZZContactsTableViewCell *cell = (ZZContactsTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        NSString *deletename = cell.name.text;
        [query whereKey:@"Username" equalTo:currentUsername];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *currentUser, NSError *error) {
            NSMutableArray *currentList = [currentUser objectForKey:@"friendList"];
            [currentList removeObject:deletename];
            [currentUser setValue:currentList forKey:@"friendList"];
            [currentUser saveInBackground];
            friendList = currentList;
            
            PFQuery *query1 = [PFQuery queryWithClassName:@"FriendRelation"];
            [query1 whereKey:@"Username" equalTo:deletename];
            [query1 getFirstObjectInBackgroundWithBlock:^(PFObject *deleteUser, NSError *error) {
                NSMutableArray *deleteList = [deleteUser objectForKey:@"friendList"];
                [deleteList removeObject:currentUsername];
                [deleteUser setValue:deleteList forKey:@"friendList"];
                [deleteUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    Firebase *ref = [[Firebase alloc] initWithUrl: @"https://vivid-torch-7789.firebaseio.com/"];
                    Firebase *alanRef = [ref childByAppendingPath: [NSString stringWithFormat:@"FriendAccept/%@", deletename]];
                    NSDictionary *signal = @{
                                             @"reload" : @"YES"
                                             //@"message": @"June 23, 1912"
                                             };
                    [[alanRef childByAutoId] setValue:signal];
                }];
                [tableView reloadData];
                
            }];
        }];

    }
}


@end
