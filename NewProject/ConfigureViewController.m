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

@property UIView *greyView;
@property UIPickerView *teamPickerView;

@end

@implementation ConfigureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;

    if (_userName) {
        [_userNameInput setText:_userName];
    }

    if (_favoriteTeam) {
        [_favoriteTeamInput setText:_favoriteTeam];
    }

    
    if (_userPortrait) {
        int portraitRow = [[_userPortrait substringToIndex:1] intValue];
        NSIndexPath *index = [NSIndexPath indexPathForItem:portraitRow inSection:0];
        [_userPortraitCollection selectItemAtIndexPath:index animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
    }
    
    
    [_userNameInput setDelegate:self];
    [_favoriteTeamInput setDelegate:self];
    
    _greyView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [_greyView setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.5]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapPicker)];
    [_greyView addGestureRecognizer:tapGesture];
    
    
    CGRect pickerRect = [_greyView bounds];
    pickerRect.origin.y = pickerRect.size.height/1.5;
    pickerRect.size.height = pickerRect.size.height/3.0;
    _teamPickerView = [[UIPickerView alloc] initWithFrame:pickerRect];
    [_teamPickerView setDataSource:self];
    [_teamPickerView setDelegate:self];
    _teamPickerView.showsSelectionIndicator = YES;
    _teamPickerView.backgroundColor = [UIColor whiteColor];
    
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
    if (_userName && _userPortrait && _favoriteTeam) {
        _userName = _userNameInput.text;
        _favoriteTeam = _favoriteTeamInput.text;
        NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
        [defaults setValue:_userName forKey:@"userName"];
        [defaults setValue:_userPortrait forKey:@"userPortrait"];
        [defaults setValue:_favoriteTeam forKey:@"favoriteTeam"];
        UINavigationController *navController = [self navigationController];
        [navController popViewControllerAnimated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Complete Profile" message:@"Please select a display name, favorite team and display image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}




- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.favoriteTeamInput) {
        
        if ([_userNameInput isFirstResponder]) {
            _userName = [_userNameInput text];
            [_userNameInput resignFirstResponder];
        }

        [self.view addSubview:_greyView];
        int idx = 0;
        if (_favoriteTeam) {
            for  (int i=0; i<[_dataArray count]; i++) {
                if ([[_dataArray objectAtIndex:i] isEqualToString:_favoriteTeam]) {
                    idx = i;
                }
            }
        }
        [_teamPickerView selectRow:idx inComponent:0 animated:YES];
        [_greyView addSubview:_teamPickerView];
        
        return NO;
    }
    
    return YES;
}

- (void) didTapPicker {
    _favoriteTeamInput.text = [_dataArray objectAtIndex:[_teamPickerView selectedRowInComponent:0]];
    _favoriteTeam = _favoriteTeamInput.text;
    [_teamPickerView removeFromSuperview];
    [_greyView removeFromSuperview];
}



-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// Total rows in our component.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_dataArray count];
}

// Display each row's data.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_dataArray objectAtIndex: row];
}

// Do something with the selected row.
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"You selected this: %@", [_dataArray objectAtIndex: row]);
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
    if ([_userNameInput isFirstResponder]) {
        _userName = [_userNameInput text];
        [_userNameInput resignFirstResponder];
    }

    
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

