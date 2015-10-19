//
//  ZZChatView.m
//  Zzazan
//
//  Created by Frank_Liu on 3/5/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import "ZZChatView.h"
#import "JSQMessages.h"
#import <Parse/Parse.h>
#import <Firebase/Firebase.h>

@interface ZZChatView ()
@property (nonatomic, strong) NSMutableArray *chatData;
@property (nonatomic, strong) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (nonatomic, strong) JSQMessagesBubbleImage *incomingBubbleImageData;
@property (nonatomic, strong) JSQMessagesBubbleImageFactory *bubbleFactory;


@end
NSString *room;
NSInteger *isFirst;

@implementation ZZChatView
@synthesize senderName;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self scrollToBottomAnimated:YES];
    isFirst = 0;
    
    self.senderId = [[PFUser currentUser] objectForKey:@"username"];
    self.title = [NSString stringWithFormat:@"%@", self.senderId];
    self.senderDisplayName = self.senderId;
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    self.showLoadEarlierMessagesHeader = YES;
    self.chatData = [[NSMutableArray alloc] init];
    self.bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] initWithBubbleImage:[UIImage jsq_bubbleRegularStrokedImage] capInsets:UIEdgeInsetsZero];
    self.outgoingBubbleImageData = [self.bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    self.incomingBubbleImageData = [self.bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleBlueColor]];
    NSString *username = [[PFUser currentUser] objectForKey:@"username"];
    NSComparisonResult result = [username compare:self.senderName];
    if (result == NSOrderedDescending){
        room = [NSString stringWithFormat:@"%@%@",username,self.senderName];
    }else{
        room = [NSString stringWithFormat:@"%@%@", self.senderName, username];
    }
    
    Firebase *ref = [[Firebase alloc] initWithUrl: @"https://vivid-torch-7789.firebaseio.com/"];
    Firebase *alanRef = [ref childByAppendingPath: [NSString stringWithFormat:@"privateChatRoom/%@", room]];
  
    [alanRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        if ([snapshot.value[@"reload"] isEqual:@"YES"]){
            JSQMessage *message = [[JSQMessage alloc] initWithSenderId:snapshot.value[@"name"]
                                                     senderDisplayName:snapshot.value[@"name"]
                                                                  date:[NSDate date]
                                                                  text:snapshot.value[@"text"]];
            if (isFirst == 0){
                [self.chatData addObject:message];
                [self.collectionView reloadData];
            }else{
                if (![self.senderId isEqual:snapshot.value[@"name"]]){
                    [self.chatData addObject:message];
                    [self.collectionView reloadData];
                }
            }
        }
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
 
    self.collectionView.collectionViewLayout.springinessEnabled = NO;
}

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    /**
     *  Sending a message. Your implementation of this method should do *at least* the following:
     *
     *  1. Play sound (optional)
     *  2. Add new id<JSQMessageData> object to your data source
     *  3. Call `finishSendingMessage`
     */

    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:self.senderId
                                             senderDisplayName:senderDisplayName
                                                          date:date
                                                          text:text];
    
    
    NSDictionary *signal = @{
                             @"reload" : @"YES",
                             @"name": self.senderId,
                             @"text": text
                             };
    Firebase *ref = [[Firebase alloc] initWithUrl: @"https://vivid-torch-7789.firebaseio.com/"];
    Firebase *alanRef = [ref childByAppendingPath: [NSString stringWithFormat:@"privateChatRoom/%@", room]];
    [[alanRef childByAutoId] setValue:signal];
    [self.chatData addObject:message];
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"username" equalTo:self.senderName];
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"user" matchesQuery:userQuery];
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:pushQuery]; // Set our Installation query
    NSDictionary *data1 = @{
                            @"alert": [NSString stringWithFormat:@"%@: %@", self.senderId, text],
                            @"type": @"message",
                            @"badge": @"increment"
                            };
    
    [push setData:data1];
    [push sendPushInBackground];
    isFirst = (NSInteger*)1;
    
    [self finishSendingMessageAnimated:YES];
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.chatData objectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.chatData objectAtIndex:indexPath.item];
    NSLog(@"Message sender%@", message.senderId);
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubbleImageData;
    } else {
        return self.incomingBubbleImageData;
    }
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.chatData objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
  //  return nil;
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.chatData objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.chatData count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    JSQMessage *message = [self.chatData objectAtIndex:indexPath.item];
   
    if (!message.isMediaMessage) {
        
        if ([message.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor blackColor];
        }
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    if (self.automaticallyScrollsToMostRecentMessage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self scrollToBottomAnimated:YES];
            [self.collectionView.collectionViewLayout invalidateLayout];
        });
    }

    return cell;
}

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [self.chatData objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.chatData objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}

@end
