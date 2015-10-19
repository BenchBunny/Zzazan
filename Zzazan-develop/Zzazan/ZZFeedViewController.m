//
//  ZZFeedViewController.m
//  Zzazan
//
//  Created by Yiming Jiang on 3/17/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import "ZZFeedViewController.h"
#import "ZZUtility.h"
//#import "MJRefresh.h"
#import "ZZCommentsViewController.h"
#import "ZZConstant.h"
#import "ZZFeedPost.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SVProgressHUD.h"

//static const CGFloat MJDuration = 1.0;

@interface ZZFeedViewController () <ZZCommmentViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *dataSourceModel;

@end

@implementation ZZFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Circle"];
    
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Set up data source

- (void)setupDataSourceModel {
    self.dataSourceModel = [NSMutableArray array];
    [SVProgressHUD showWithStatus:@"Connecting"];
    //UIImage *image = [UIImage imageNamed:@"UserAvatarDemo.png"];
    
    [PFCloud callFunctionInBackground:@"get_circle"
                       withParameters:@{}
                                block:^(id result, NSError *error) {
        if (!error) {
            NSArray *resultArray = (NSArray *)result;
            if (resultArray.count > 0) {
                for (NSDictionary *dict in resultArray) {
                    ZZFeedPost *eachPost = [[ZZFeedPost alloc] initWithName: dict[@"name"]
                                                                     AvatarURL: dict[@"url"]
                                                                   Activity: dict[@"activity_name"]
                                                              NumberOfLikes: [dict[@"number_of_likes"] intValue]
                                                                       Date:@""
                                                                   ObjectId:dict[@"objectId"]];
                    if ([dict[@"do_i_like_this_post"] intValue] == 1) {
                        eachPost.doILikeThisPost = YES;
                    }
                    
                    NSArray *commentsArray = (NSArray *)dict[@"comments"];
                    if (commentsArray.count > 0) {
                        for (NSDictionary *commentDict in commentsArray) {
                            ZZComment *each_comment = [[ZZComment alloc] initWithName:commentDict[@"username"] Comment:commentDict[@"content"]];
                            [eachPost addAComment:each_comment];
                        }
                    }
                    [self.dataSourceModel addObject:eachPost];
                }
            }
            [SVProgressHUD dismiss];
            [self.tableView reloadData];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupDataSourceModel];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceModel.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZFeedPost *eachPost = self.dataSourceModel[indexPath.row];
    
    CGFloat height = 0.0f;
    CGFloat commentViewWidth = 0.0f, commentFontSize = 0.0f, commentMargin = 0.0f;
    CGFloat viewMoreCommentsHeight = 0.0f, likeCommentShareButtonHeight = 0.0f;
    
    height = (eachPost.likes != 0) ? kCommentIconToTopWithLike5 : kCommentIconToTopWithoutLike5;
    commentViewWidth = kCommentLabelWidth5;
    commentFontSize = kCommentFontSize5;
    commentMargin = kCommentMargin5;
    viewMoreCommentsHeight = kViewMoreCommentsButtonHeight5;
    likeCommentShareButtonHeight = kLikeButtonHeight5;
    
    if (eachPost.comments.count > 0 && eachPost.comments.count <= 5) {
        for (int i = 0; i < eachPost.comments.count; i++) {
            ZZComment *eachComment = eachPost.comments[i];
            NSString *eachCommentString = [NSString stringWithFormat:@"%@  %@", eachComment.name, eachComment.content];
            height += [ZZUtility calculateCommentLabelHeight:eachCommentString withViewWidth:commentViewWidth withFont:[UIFont systemFontOfSize:commentFontSize]];
            height += commentMargin;
        }
    }
    else if (eachPost.comments.count > 5) {
        height += viewMoreCommentsHeight+commentMargin;
        
        for (int i = (int)eachPost.comments.count-5; i < eachPost.comments.count; i++) {
            ZZComment *eachComment = eachPost.comments[i];
            NSString *eachCommentString = [NSString stringWithFormat:@"%@  %@", eachComment.name, eachComment.content];
            height += [ZZUtility calculateCommentLabelHeight:eachCommentString withViewWidth:commentViewWidth withFont:[UIFont systemFontOfSize:commentFontSize]];
            height += commentMargin;
        }
    }
    height += likeCommentShareButtonHeight;
    height += 20;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    
    ZZFeedTableViewCell *cell = (ZZFeedTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:identifier];
    
    ZZFeedPost *post = self.dataSourceModel[indexPath.row];
    //if (cell == nil) {
    cell = [[ZZFeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier
                                            postModel:post];
    //}
    
    cell.delegate = self;
    cell.cellIndex = indexPath.row;
    
    [cell.avatar sd_setImageWithURL: [NSURL URLWithString:post.avatarURL]
                            placeholderImage: [UIImage imageNamed:@"AvatarPlaceHolder.png"]];
    
    return cell;
}

#pragma mark - Action Receiver

- (void)didClickOnCellAtIndex:(NSInteger)cellIndex withData:(id)data {
    // Do additional actions as required.

    NSString *action = (NSString *)data;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellIndex inSection:0];
    ZZFeedPost *post = self.dataSourceModel[indexPath.row];
    BOOL isIncrement = YES;
    if ([action isEqualToString:@"like"]) {
        if (post.doILikeThisPost) {
            post.doILikeThisPost = NO;
            post.likes --;
            isIncrement = NO;
        }
        else {
            post.doILikeThisPost = YES;
            post.likes ++;
        }
        
        // update number of likes and users like list
        PFQuery *likeQuery = [PFQuery queryWithClassName:@"TurnOnTime"];
        [likeQuery getObjectInBackgroundWithId:post.objectId block:^(PFObject *object, NSError *error) {
            [object setObject:[NSNumber numberWithInteger:post.likes] forKey:@"number_of_likes"];
            if (isIncrement) {
                [object addObject:[PFUser currentUser].username forKey:@"likeList"];
            }
            else {
                [object removeObject:[PFUser currentUser].username forKey:@"likeList"];
            }
            [object saveInBackground];
        }];
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if ([action isEqualToString:@"comment"] || [action isEqualToString:@"view_more_comments"]) {
        ZZCommentsViewController *commentsVC = [[ZZCommentsViewController alloc] initWithCommentsArray:post.comments];
        commentsVC.rowNumber = indexPath.row;
        commentsVC.hidesBottomBarWhenPushed = YES;
        commentsVC.objectId = post.objectId;
        commentsVC.delegate = self;
        [self.navigationController pushViewController:commentsVC animated:YES];
    }
}

#pragma mark - ZZCommmentViewControllerDelegate

- (void)updateCommentsWithArray:(NSMutableArray *)commentsArray atIndex:(NSInteger)rowIndex {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    ZZFeedPost *post = self.dataSourceModel[indexPath.row];
    post.comments = commentsArray;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end
