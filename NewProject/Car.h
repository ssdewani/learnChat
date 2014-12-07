//
//  Car.h
//  NewProject
//
//  Created by Salim Dewani on 11/18/14.
//  Copyright (c) 2014 Salim Dewani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol Car <NSObject>

@property (nonatomic, copy) NSArray *wheels;
@property (nonatomic, strong) UIColor *bodyColor;
@property (nonatomic, copy) NSArray *doors;


@end
