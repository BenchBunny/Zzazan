//
//  ZZConfirmFriendViewController.m
//  Zzazan
//
//  Created by Yiming Jiang on 2/14/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import "ZZAcceptFriendsViewController.h"
#import "ZZAcceptFriendsTableViewCell.h"
#import "ZZRequestButtonView.h"
#import <Parse/Parse.h>
#import <Firebase/Firebase.h>

@interface ZZAcceptFriendsViewController ()

@end

@implementation ZZAcceptFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 60;
    
    [self.navigationItem setTitle:@"Accept Friends"];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZZAcceptFriendsTableViewCell" bundle:nil] forCellReuseIdentifier:@"AcceptFriendsCellIdentifier"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.definesPresentationContext = YES;
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:@"FriendRequest"];
    NSString *currentName = [[PFUser currentUser] objectForKey:@"username"];
    [query whereKey:@"RequestReceiver" equalTo:currentName];
    return query;
}

#pragma mark - Table view data source

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    ZZAcceptFriendsTableViewCell *cell = (ZZAcceptFriendsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"AcceptFriendsCellIdentifier" forIndexPath:indexPath];
    
    CGRect cellBounds = [[cell contentView] bounds];
    
    cell.thumbnail.image = [UIImage imageNamed:@"UserAvatarDemo.png"];
    cell.name.text = [object objectForKey:@"RequestSender"];
    
    // draw added label
    UILabel* addedLabel = [[UILabel alloc] initWithFrame:
                           CGRectMake(cellBounds.size.width-20-40, 17.0, 40, 26.0)];
    addedLabel.text = @"Added";
    addedLabel.font = [UIFont systemFontOfSize:12];
    addedLabel.textColor = [UIColor grayColor];
    [[cell contentView] addSubview:addedLabel];
    
    // draw accept button
    ZZRequestButtonView* acceptButton = [ZZRequestButtonView buttonWithType:UIButtonTypeRoundedRect];
    acceptButton.selectedUser = cell.name.text;
    [acceptButton setTitle:@"Accept" forState:UIControlStateNormal];
    acceptButton.layer.cornerRadius = 5;
    [acceptButton setFrame:CGRectMake(cellBounds.size.width-20-60, 17.0, 60, 26.0)];
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
    NSString *requestSender = currButton.selectedUser;
    PFQuery *queryCurr = [PFQuery queryWithClassName:@"FriendRelation"];
    NSString *currUserName = [[PFUser currentUser] objectForKey:@"username"];
    [queryCurr whereKey:@"Username" equalTo:currUserName];
    [queryCurr getFirstObjectInBackgroundWithBlock:^(PFObject *curr, NSError *error) {
        NSMutableArray *receiverList = [curr objectForKey:@"friendList"];
        if (![receiverList containsObject:requestSender]){
            [curr addObject:requestSender forKey:@"friendList"];
            [curr saveInBackground];
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Success"
                                                             message:@"Successfully added"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
            [alert setTitle:@"acceptsuccess"];
            [alert show];
            PFQuery *qSender = [PFQuery queryWithClassName:@"FriendRelation"];
            [qSender whereKey:@"Username" equalTo:requestSender];
            [qSender getFirstObjectInBackgroundWithBlock:^(PFObject *senderObject, NSError *error) {
                [senderObject addObject:currUserName forKey:@"friendList"];
                [senderObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    Firebase *ref = [[Firebase alloc] initWithUrl: @"https://vivid-torch-7789.firebaseio.com/"];
                    Firebase *alanRef = [ref childByAppendingPath: [NSString stringWithFormat:@"FriendAccept/%@", requestSender]];
                    Firebase *alanRef1 = [ref childByAppendingPath: [NSString stringWithFormat:@"FriendAccept/%@", currUserName]];
                    NSDictionary *signal = @{
                                             @"reload" : @"YES"
                                             //@"message": @"June 23, 1912"
                                             };
                    [[alanRef childByAutoId] setValue:signal];
                    [[alanRef1 childByAutoId] setValue:signal];
                }];
                
            }];
            
            
            
        }else{
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Failed"
                                                             message:@"Whoops!"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
            [alert show];
        }
        
    }];
    
    PFQuery *query = [PFQuery queryWithClassName:@"FriendRequest"];
    [query whereKey:@"RequestSender" equalTo:requestSender];
    [query findObjectsInBackgroundWithBlock:^(NSArray *checkResult, NSError *error) {
        for (PFObject *ob in checkResult){
            if ([currUserName isEqualToString:[ob objectForKey:@"RequestReceiver"]]){
                [ob deleteInBackground];
            }
        }
        
    }];
    
    [currButton removeFromSuperview];
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
