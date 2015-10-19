//
//  ZZCommentsViewController.m
//  Zzazan
//
//  Created by Yiming Jiang on 4/6/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import "ZZCommentsViewController.h"
#import "ZZUtility.h"
#import "ZZCommentsTableViewCell.h"
#import "ZZConstant.h"
#import <Parse/Parse.h>

@interface ZZCommentsViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation ZZCommentsViewController

- (instancetype)initWithCommentsArray:(NSMutableArray *)commentsArray {
    self = [super init];
    if (self) {
        self.commentsArray = commentsArray;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Comments";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.commentTextField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIEdgeInsets inset = self.tableView.contentInset;
    inset.top = 0.0f;
    self.tableView.contentInset = inset;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        [self.delegate updateCommentsWithArray:self.commentsArray atIndex:self.rowNumber];
    }
}

#pragma mark - UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"%ld", self.commentsArray.count);
    return self.commentsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0f;
    height += kCommentCommentLabelToTop5;
    ZZComment *comment = self.commentsArray[indexPath.row];
    height += [ZZUtility calculateCommentLabelHeight:comment.content withViewWidth:kCommentCommentLabelWidth5 withFont:[UIFont systemFontOfSize:kCommentCommentLabelFontSize5]];
    height += 15;
    return height;
}

#pragma mark - UITableView dataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZCommentsTableViewCell *cell = (ZZCommentsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    
    if (!cell) {
        cell = [[ZZCommentsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier" comment:self.commentsArray[indexPath.row]];
    }
    
    return cell;
}

#pragma mark - Keyboard notification center

- (void)keyboardWillShow:(NSNotification *)notif {

    CGRect frame = [[[notif userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIEdgeInsets inset = self.tableView.contentInset;
    
    inset.top = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
    
    self.tableView.contentInset = inset;
    
    NSTimeInterval duration = [[[notif userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 0, [ZZUtility getScreenWidth], [ZZUtility getScreenHeight] - frame.size.height);
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notif {
    UIEdgeInsets inset = self.tableView.contentInset;
    self.tableView.contentInset = inset;
    NSTimeInterval duration = [[[notif userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration
                     animations:^{
                         self.view.frame = CGRectMake(0, 0, [ZZUtility getScreenWidth], [ZZUtility getScreenHeight]);
                     }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

#pragma mark - Button action

- (IBAction)sendButtonPressed:(id)sender {
    //NSLog(@"%@", self.commentTextField.text);
    ZZComment *newComment = [[ZZComment alloc] init];
    newComment.name = [PFUser currentUser].username;
    newComment.content = self.commentTextField.text;
    [self.commentsArray addObject:newComment];
    [self.commentTextField resignFirstResponder];
    self.commentTextField.text = @"";
    
    // send object to parse
    PFObject *comment = [PFObject objectWithClassName:@"Comment"];
    comment[@"username"] = newComment.name;
    comment[@"content"] = newComment.content;
    [comment saveInBackground];
    
    PFQuery *query = [PFQuery queryWithClassName:@"TurnOnTime"];
    [query getObjectInBackgroundWithId:self.objectId block:^(PFObject *object, NSError *error) {
        PFRelation *commentRelation = [object relationForKey:@"commentsList"];
        [commentRelation addObject:comment];
        [object saveInBackground];
    }];
    
    [self.tableView reloadData];
}

@end
