//
//  ZZAddFriendViewController.m
//  Zzazan
//
//  Created by Yiming Jiang on 2/14/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import "ZZAddFriendViewController.h"
#import "ZZAcceptFriendsTableViewCell.h"
#import "ZZRequestButtonView.h"
#import <Parse/Parse.h>
#import "ZZUtility.h"

@interface ZZAddFriendViewController ()
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) UITableViewController *searchResultsTableViewController;
@property (strong, nonatomic) NSMutableArray *results;

@end

@implementation ZZAddFriendViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"Add Friend"];
    
    self.results = [[NSMutableArray alloc] init];
    
    // A table view for results.
    UITableView *searchResultsTableView = [[UITableView alloc] initWithFrame:self.tableView.frame];
    searchResultsTableView.dataSource = self;
    searchResultsTableView.delegate = self;
    
    // Registration of reuse identifiers.
    [searchResultsTableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"username"];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"username"];
    
    // Init a search results table view controller and setting its table view.
    self.searchResultsTableViewController = [[UITableViewController alloc] init];
    self.searchResultsTableViewController.tableView = searchResultsTableView;
    
    // Init a search controller with its table view controller for results.
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultsTableViewController];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    
    // Make an appropriate size for search bar and add it as a header view for initial table view.
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    // Enable presentation context.
    self.definesPresentationContext = YES;
    
    self.tableView.rowHeight = 60;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZZAcceptFriendsTableViewCell" bundle:nil] forCellReuseIdentifier:@"AcceptFriendsCellIdentifier"];
    
    self.searchResultsTableViewController.tableView.rowHeight = 60;
    
    [self.searchResultsTableViewController.tableView registerNib:[UINib nibWithNibName:@"ZZAcceptFriendsTableViewCell" bundle:nil] forCellReuseIdentifier:@"AcceptFriendsCellIdentifier"];
    self.searchController.searchBar.accessibilityLabel = @"searchbar";
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //Hide
    self.definesPresentationContext = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}


- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self){
        self.parseClassName = @"User";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 15;
    }
    return self;
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFUser query];
    return query;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView){
        return 10;
    }else{
        return [self.results count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZAcceptFriendsTableViewCell *cell = (ZZAcceptFriendsTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"AcceptFriendsCellIdentifier"];
    //CGRect cellBounds = [[cell contentView] bounds];
    
    cell.thumbnail.image = [UIImage imageNamed:@"UserAvatarDemo.png"];
    
//    // draw added label
//    UILabel* addedLabel = [[UILabel alloc] initWithFrame:
//                           CGRectMake(cellBounds.size.width-20-40, 17.0, 40, 26.0)];
//    addedLabel.text = @"Sent";
//    addedLabel.font = [UIFont systemFontOfSize:12];
//    addedLabel.textColor = [UIColor grayColor];
//    [[cell contentView] addSubview:addedLabel];
    
    
    if (tableView == self.tableView){
        //cell.textLabel.text = self.results[indexPath.row];
        //cell.name.text = [object objectForKey:@"username"];
        cell.hidden = YES;
    }else{
        PFObject *searchedUser = [self.results objectAtIndex:indexPath.row];
        NSString *resultUser = [searchedUser objectForKey:@"username"];
        //NSLog(@"%@", resultUser);
        cell.name.text = resultUser;
        
    }
    
    
    // draw accept button
    ZZRequestButtonView *acceptButton = [ZZRequestButtonView buttonWithType:UIButtonTypeRoundedRect];
    [acceptButton setTitle:@"Request" forState:UIControlStateNormal];
    acceptButton.layer.cornerRadius = 5;
    acceptButton.selectedUser = cell.name.text;
    
    CGFloat buttonX = [ZZUtility getScreenWidth]-20-60;
    [acceptButton setFrame:CGRectMake(buttonX, 17.0, 60, 26.0)];
    //NSLog(@"%f", cellBounds.size.width-20-60);
    acceptButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [acceptButton setBackgroundColor:[UIColor colorWithRed:83.0f/255.0 green:179.0f/255.0 blue:16.0f/255.0 alpha:1.0]];
    [acceptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [acceptButton addTarget:self action:@selector(acceptButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    acceptButton.accessibilityLabel = cell.name.text;
    [[cell contentView] addSubview:acceptButton];
    return cell;
}


- (void) acceptButtonPressed:(id)sender {
    ZZRequestButtonView *currButton = (ZZRequestButtonView *)sender;
    NSString *receiveUer = currButton.selectedUser;
    NSString *requestSender = [[PFUser currentUser] objectForKey:@"username"];
    //Delete all duplicate
    PFQuery *query = [PFQuery queryWithClassName:@"FriendRequest"];
    [query whereKey:@"RequestSender" equalTo:requestSender];
    [query findObjectsInBackgroundWithBlock:^(NSArray *duplicateRequest, NSError *error) {
        for (PFObject *ii in duplicateRequest){
            if ([[ii objectForKey:@"RequestReceiver"] isEqualToString:receiveUer]){
                [ii deleteInBackground];
            }
        }
    }];
    
    //check whether friends already
    PFQuery *duplicateQuery = [PFQuery queryWithClassName:@"FriendRelation"];
    [duplicateQuery whereKey:@"Username" equalTo:receiveUer];
    [duplicateQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        NSArray *checkResult = [object objectForKey:@"friendList"];
        if ([checkResult containsObject:requestSender]){
            UIAlertView * friends =[[UIAlertView alloc ] initWithTitle:@"Denied"
                                                               message:@"You are already friends"
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles: nil];
            [friends show];
        }else{
            PFObject *requestForm = [PFObject objectWithClassName:@"FriendRequest"];
            [requestForm setObject:receiveUer forKey:@"RequestReceiver"];
            [requestForm setObject:requestSender forKey:@"RequestSender"];
            [requestForm saveEventually:^(BOOL succeed, NSError *error){
                if (!error){
                    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Success"
                                                                     message:@"Request has been successfully sent"
                                                                    delegate:self
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles: nil];
                    [alert setTitle:@"addsuccess"];
                    [alert show];
                    PFQuery *userQuery = [PFUser query];
                    [userQuery whereKey:@"username" equalTo:receiveUer];
                    
                    // Find devices associated with these users
                    PFQuery *pushQuery = [PFInstallation query];
                    [pushQuery whereKey:@"user" matchesQuery:userQuery];
                    
                    // Send push notification to query
                    PFPush *push = [[PFPush alloc] init];
                    [push setQuery:pushQuery]; // Set our Installation query
                    NSDictionary *data1 = @{
                                            @"alert": [NSString stringWithFormat:@"You got a friend request from %@",requestSender],
                                            @"type": @"request",
                                            @"badge": @"increment"
                                            };
                    
                    
                    [push setData:data1];
                    [push sendPushInBackground];
                    
                }
            }];
        }
        
    }];
    /* NSInteger *duplicate = 0;
     for (PFObject *i in checkResult){
     NSLog(@"%@", [i objectForKey:@"user2"]);
     if ([[i objectForKey:@"user2"] isEqualToString:requestSender]){
     duplicate = duplicate + 1;
     }
     }*/
    
    //NSLog(@"%@ %@ %lu", receiveUer, requestSender, [checkResult count]);
    
    
    [currButton removeFromSuperview];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
-(void)filterResults:(NSString *)searchTerm{
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" containsString:searchTerm];
    [query findObjectsInBackgroundWithBlock:^(NSArray *r, NSError *error) {
        [self.results removeAllObjects];
        NSString *username = [[PFUser currentUser] objectForKey:@"username"];
        NSMutableArray *result = [[NSMutableArray alloc] init];
        for (PFObject *i in r){
            if (![[i objectForKey:@"username"] isEqual:username])
                [result addObject:i];
        }
        [self.results addObjectsFromArray:result];
        [self.tableView reloadData];
    }];
    
    // NSLog(@"%lu", [r count]);
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    [self filterResults:self.searchController.searchBar.text];
    [self.searchResultsTableViewController.tableView reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZAcceptFriendsTableViewCell* currCell = (ZZAcceptFriendsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    for (UIView* view in currCell.contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* currButton = (UIButton *)view;
            [currButton setBackgroundColor:[UIColor colorWithRed:83.0f/255.0 green:179.0f/255.0 blue:16.0f/255.0 alpha:1.0]];
        }
    }
}

@end
