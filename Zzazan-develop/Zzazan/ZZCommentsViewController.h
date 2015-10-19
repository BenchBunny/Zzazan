//
//  ZZCommentsViewController.h
//  Zzazan
//
//  Created by Yiming Jiang on 4/6/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZZCommmentViewControllerDelegate <NSObject>

- (void)updateCommentsWithArray:(NSMutableArray *)commentsArray atIndex:(NSInteger)rowIndex;

@end

@interface ZZCommentsViewController : UIViewController

@property (weak, nonatomic) NSMutableArray *commentsArray;
@property (nonatomic) NSInteger rowNumber;
@property (nonatomic, assign) id <ZZCommmentViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *objectId;

- (instancetype)initWithCommentsArray:(NSMutableArray *)commentsArray;

@end
