//
//  ChatViewController.h
//  NewProject
//
//  Created by Salim Dewani on 11/18/14.
//  Copyright (c) 2014 Salim Dewani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSQMessagesViewController/JSQMessages.h> 
#import "ChatDataModel.h"
#import <Quickblox/Quickblox.h>

@interface ChatViewController : JSQMessagesViewController <JSQMessagesCollectionViewDataSource, JSQMessagesCollectionViewDelegateFlowLayout, QBChatDelegate, QBActionStatusDelegate>

@property ChatDataModel *dataModel;
@property NSString *chatRoomJID;
@property NSString *senderPortrait;
@property int currentUserID;


@end
