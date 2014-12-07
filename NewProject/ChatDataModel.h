//
//  ChatDataModel.h
//  NewProject
//
//  Created by Salim Dewani on 11/26/14.
//  Copyright (c) 2014 Salim Dewani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSQMessages.h"


@interface ChatDataModel : NSObject

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableDictionary *userPortraits;
@property (strong, nonatomic) NSMutableDictionary *userPortraitFileNames;
@property (strong, nonatomic) NSMutableDictionary *userNames;

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

- (void) addPortraitFile: (NSString *) userID;

@end
