//
//  PortraitCollectionViewCell.m
//  NewProject
//
//  Created by Salim Dewani on 11/21/14.
//  Copyright (c) 2014 Salim Dewani. All rights reserved.
//

#import "PortraitCollectionViewCell.h"

@implementation PortraitCollectionViewCell

- (void)setPortraitFile:(NSString *)portraitFile {
    _portraitFile = portraitFile;
    self.portraitImage.image = [UIImage imageNamed:portraitFile];
}

@end
