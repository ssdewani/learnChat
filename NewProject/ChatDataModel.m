//
//  ChatDataModel.m
//  NewProject
//
//  Created by Salim Dewani on 11/26/14.
//  Copyright (c) 2014 Salim Dewani. All rights reserved.
//

#import "ChatDataModel.h"

@implementation ChatDataModel

- (instancetype)init {
    self = [super init];
    if (self) {

        self.messages = [NSMutableArray new];
        self.userNames = [NSMutableDictionary new];
        self.userPortraits = [NSMutableDictionary new];
        self.userPortraitFileNames = [NSMutableDictionary new];
        NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
        NSString * mainUserID = [defaults objectForKey:@"userID"];

        
        
        [self.userNames setObject:[defaults objectForKey:@"userName"] forKey:mainUserID];
        [self.userPortraitFileNames setObject:[defaults objectForKey:@"userPortrait"] forKey:mainUserID];
        
        [self addPortraitFile:mainUserID];
        
       
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
        
    }
    
    return self;
}

- (void) addPortraitFile: (NSString *) userID {
    JSQMessagesAvatarImage *userImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:[self.userPortraitFileNames objectForKey:userID]] diameter:30.0f];
    [self.userPortraits setObject:userImage forKey:userID];
}


@end
