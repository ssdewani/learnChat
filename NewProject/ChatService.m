//
//  ChatService.m
//  NewProject
//
//  Created by Salim Dewani on 12/7/14.
//  Copyright (c) 2014 Salim Dewani. All rights reserved.
//

#import "ChatService.h"
#import <Quickblox/Quickblox.h>
typedef void(^CompletionBlock)();


@interface ChatService () <QBChatDelegate>

@property (copy) QBUUser *currentUser;
@property (retain) NSTimer *presenceTimer;
@property (copy) CompletionBlock loginCompletionBlock;


@end

@implementation ChatService

+ (instancetype)instance {
    static id instance_ = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance_ = [[self alloc] init];
    });
    
    return instance_;
}

- (id)init{
    self = [super init];
    if(self){
        [QBChat instance].delegate = self;
    }
    return self;
}

- (void)loginWithUser:(QBUUser *)user completionBlock:(void(^)())completionBlock {
    self.loginCompletionBlock = completionBlock;
    self.currentUser = user;
    [[QBChat instance] loginWithUser:user];
}

- (void)loginWithUser:(QBUUser *)user {
    self.currentUser = user;
    [[QBChat instance] loginWithUser:user];
}


- (void)sendMessage:(QBChatMessage *)message toRoom:(QBChatRoom *)chatRoom{
    [[QBChat instance] sendChatMessage:message toRoom:chatRoom];
}

- (void)joinRoom:(QBChatRoom *)room {
    [room joinRoomWithHistoryAttribute:@{@"maxstanzas": @"10"}];
}

- (void)leaveRoom:(QBChatRoom *)room{
    [[QBChat instance] leaveRoom:room];
}

- (void)chatDidLogin{
    // Start sending presences
    [self.presenceTimer invalidate];
    self.presenceTimer = [NSTimer scheduledTimerWithTimeInterval:30
                                                          target:[QBChat instance] selector:@selector(sendPresence)
                                                        userInfo:nil repeats:YES];
    if(self.loginCompletionBlock != nil){
        self.loginCompletionBlock();
        self.loginCompletionBlock = nil;
    }
}

- (void)chatDidFailWithError:(NSInteger)code{
    // relogin here
    [[QBChat instance] loginWithUser:self.currentUser];
}

- (void)chatRoomDidEnter:(QBChatRoom *)room{
    NSLog(@"Room is called : %@",room);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"roomEnteredNotification"
                                                        object:nil userInfo:@{@"room": room}];
}

- (void)chatRoomDidReceiveMessage:(QBChatMessage *)message fromRoomJID:(NSString *)roomJID{
    NSLog(@"New message: %@", message);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"messageReceivedNotication"
                                                        object:nil userInfo:@{@"message": message,@"room":roomJID}];
}

@end
