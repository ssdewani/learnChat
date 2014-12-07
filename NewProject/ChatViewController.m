//
//  ChatViewController.m
//  NewProject
//
//  Created by Salim Dewani on 11/18/14.
//  Copyright (c) 2014 Salim Dewani. All rights reserved.
//

#import "ChatViewController.h"
#import <Quickblox/Quickblox.h>

@interface ChatViewController ()

@property int currentUserID;
@property QBChatRoom *chatRoom;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataModel = [[ChatDataModel alloc] init];

    self.senderId = [[[NSUserDefaults alloc] init] objectForKey:@"userID"];
    self.senderDisplayName = [[[NSUserDefaults alloc] init] objectForKey:@"userName"];
    self.senderPortrait = [[[NSUserDefaults alloc] init] objectForKey:@"userPortrait"];
    self.inputToolbar.hidden = YES;
    [self loginToChat];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[QBChat instance] logout];
}



- (void) loginToChat {
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    NSString * uuid = [defaults objectForKey:@"userID"];

    QBSessionParameters *parameters = [QBSessionParameters new];
    parameters.userLogin = uuid;
    parameters.userPassword = uuid;
    [QBRequest createSessionWithExtendedParameters:parameters successBlock:^(QBResponse *response, QBASession *session) {
        QBUUser *currentUser = [QBUUser user];
        currentUser.ID = session.userID; // your current user's ID
        currentUser.password = uuid; // your current user's password
        _currentUserID = (int)currentUser.ID;
        // set Chat delegate
        [QBChat instance].delegate = self;
        
        // login to Chat
        [[QBChat instance] loginWithUser:currentUser];
        
     } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"error: %@", response.error);
    }];
    
    // Do any additional setup after loading the view.
}


#pragma mark  -sending and receiving messages

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    QBChatMessage *qbMessage = [QBChatMessage message];
    qbMessage.text = text;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"save_to_history"] = @YES;
    params[@"userID"] = self.senderId;
    params[@"userName"] = self.senderDisplayName;
    params[@"userPortrait"] = self.senderPortrait;
    

    [qbMessage setCustomParameters:params];
    
    [[QBChat instance] sendChatMessage:qbMessage  toRoom:self.chatRoom];
    
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                             senderDisplayName:senderDisplayName
                                                          date:date
                                                          text:text];
    
    [self.dataModel.messages addObject:message];
    [self finishSendingMessage];
}

- (void)chatRoomDidReceiveMessage:(QBChatMessage *)qbMessage fromRoomJID:(NSString *)roomJID{
    NSLog(@"New message: %@", qbMessage);
    
    
    if ([qbMessage senderID] != self.currentUserID || [qbMessage delayed]) {
        NSString *senderID = [[qbMessage customParameters]objectForKey:@"userID"];
        NSString *senderDisplayName = [[qbMessage customParameters]objectForKey:@"userName"];
        NSString *senderPortraitFile = [[qbMessage customParameters]objectForKey:@"userPortrait"];
        NSDate *date = [qbMessage datetime];
        NSString *text = [qbMessage text];
        
        if ([self.dataModel.userNames objectForKey:senderID] != senderDisplayName) {
            [self.dataModel.userNames setObject:senderDisplayName forKey:senderID];
        }
        
        if ([self.dataModel.userPortraitFileNames objectForKey:senderID] != senderPortraitFile) {
            [self.dataModel.userPortraitFileNames setObject:senderPortraitFile forKey:senderID];
            [self.dataModel addPortraitFile:senderID];
        }
        
        
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderID
                                                 senderDisplayName:senderDisplayName
                                                              date:date
                                                              text:text];
        
        [self.dataModel.messages addObject:message];
        [self finishReceivingMessage];
    }
}


#pragma mark - QBChat callbacks


- (void)chatRoomDidEnter:(QBChatRoom *)room{
    NSLog(@"room: %@", room);
    self.inputToolbar.hidden = NO;
    self.inputToolbar.contentView.leftBarButtonItem.hidden = YES;
//    [[QBChat instance] requestRoomOnlineUsers:self.chatRoom];
// joined here, now you can send and receive chat messages within this group dialog
}


- (void)chatDidReceiveMessage:(QBChatMessage *)message{
    NSLog(@"New message: %@", message);
}


- (void)chatRoomDidReceiveListOfOnlineUsers:(NSArray *)users roomJID:(NSString *)roomJID{
    NSLog(@"Room did receive list of online users %@, room JID: %@",users, roomJID);
}


- (void)chatDidLogin {
    NSString * roomName = [NSString stringWithFormat:@"16525_54842b7a535c122e380141cf@muc.chat.quickblox.com"];
    QBChatRoom *groupChatRoom = [[QBChatRoom alloc]initWithRoomJID:roomName];
    self.chatRoom = groupChatRoom;
    [self.chatRoom joinRoomWithHistoryAttribute:@{@"maxstanzas": @"50"}];
    
    
}


- (void)chatDidFailWithError:(NSInteger)code {
    NSLog(@"%ld",code);
    [self loginToChat];
}

- (void)completedWithResult:(Result *)result{
    if (result.success && [result isKindOfClass:QBChatHistoryMessageResult.class]) {
        QBChatHistoryMessageResult *res = (QBChatHistoryMessageResult *)result;
        NSArray *messages = res.messages;
        NSLog(@"Messages: %@", messages);
    }
}


#pragma mark - JSQ Views

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
   return [self.dataModel.messages objectAtIndex:indexPath.item];
    }


- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.dataModel.messages objectAtIndex:indexPath.item];

    if ([message.senderId isEqualToString:self.senderId]) {
        return self.dataModel.outgoingBubbleImageData;
    }
    
    return self.dataModel.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.dataModel.messages objectAtIndex:indexPath.item];
    return [self.dataModel.userPortraits objectForKey:message.senderId];

}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.item % 3 == 0) {
        JSQMessage *message = [self.dataModel.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.dataModel.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.dataModel.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataModel.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    
    JSQMessage *msg = [self.dataModel.messages objectAtIndex:indexPath.item];
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
    
    return cell;
}



#pragma mark - JSQMessages collection view flow layout delegate

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
    JSQMessage *currentMessage = [self.dataModel.messages objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.dataModel.messages objectAtIndex:indexPath.item - 1];
        
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
