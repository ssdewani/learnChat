//
//  PortraitCollectionViewCell.h
//  NewProject
//
//  Created by Salim Dewani on 11/21/14.
//  Copyright (c) 2014 Salim Dewani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PortraitCollectionViewCell : UICollectionViewCell

@property (copy, nonatomic) NSString * portraitFile;
@property (weak, nonatomic) IBOutlet UIImageView *portraitImage;

@end
