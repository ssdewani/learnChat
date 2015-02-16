//
//  ConfigureViewController.h
//  NewProject
//
//  Created by Salim Dewani on 11/18/14.
//  Copyright (c) 2014 Salim Dewani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface ConfigureViewController : UIViewController <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *userPortrait;
@property (nonatomic,copy) NSString *favoriteTeam;
@property NSMutableArray *dataArray;

@property (weak,nonatomic) ViewController *mainViewController;
@property (weak, nonatomic) IBOutlet UITextField *userNameInput;
@property (weak, nonatomic) IBOutlet UITextField *favoriteTeamInput;
@property (weak, nonatomic) IBOutlet UICollectionView *userPortraitCollection;
- (IBAction)confirmChanges:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end
