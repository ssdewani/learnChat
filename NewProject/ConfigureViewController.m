//
//  ConfigureViewController.m
//  NewProject
//
//  Created by Salim Dewani on 11/18/14.
//  Copyright (c) 2014 Salim Dewani. All rights reserved.
//

#import "ConfigureViewController.h"
#import "ViewController.h"
#import "PortraitCollectionViewCell.h"

@interface ConfigureViewController ()

@end

@implementation ConfigureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_userName) {
        [_userNameInput setText:_userName];
    }
    [_userNameInput setDelegate:self];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField ==self.userNameInput) {
        _userName = [textField text];
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)confirmChanges:(id)sender {
    if (_userName && _userPortrait) {
        [self.mainViewController setUserName:_userName];
        [self.mainViewController setUserPortrait:_userPortrait];
        UINavigationController *navController = [self navigationController];
        [navController popViewControllerAnimated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Pick name and avatar" message:@"Please select a name and avatar image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma uicollectionview


- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PortraitCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"PortraitCell" forIndexPath:indexPath];
      cell.portraitFile = [NSString stringWithFormat:@"%d.png",(int)[indexPath row]];
    if (cell.selected) {
        cell.backgroundColor = [UIColor lightGrayColor]; // highlight selection
    }
    else
    {
        cell.backgroundColor = [UIColor whiteColor]; // Default color
    }
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _userPortrait = [NSString stringWithFormat:@"%d.png",(int)[indexPath row]];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 2
    CGSize retval = CGSizeMake(100, 100);
    return retval;
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 15, 15, 15);
}




@end
