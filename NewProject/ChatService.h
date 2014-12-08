//
//  ChatService.h
//  NewProject
//
//  Created by Salim Dewani on 12/7/14.
//  Copyright (c) 2014 Salim Dewani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quickblox/Quickblox.h>

@interface ChatService : NSObject

+ (instancetype)instance;


- (void)loginWithUser:(QBUUser *)user completionBlock:(void(^)())completionBlock;
- (void)sendMessage:(QBChatMessage *)message toRoom:(QBChatRoom *)chatRoom;
- (void)joinRoom:(QBChatRoom *)room;
- (void)leaveRoom:(QBChatRoom *)room;

- (void)loginWithUser:(QBUUser *)user;

@end
