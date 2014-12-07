//
//  ViewController.m
//  NewProject
//
//  Created by Salim Dewani on 11/18/14.
//  Copyright (c) 2014 Salim Dewani. All rights reserved.
//

#import "ViewController.h"
#import "ConfigureViewController.h"
#import "ChatViewController.h"
#import "PortraitCollectionViewCell.h"
#import <Quickblox/Quickblox.h>
#import <MTBlockAlertView/MTBlockAlertView.h>


@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationItem.hidesBackButton = YES;
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    if ((![defaults objectForKey:@"userName"])||(![defaults objectForKey:@"userPortrait"])) {
        [self performSegueWithIdentifier: @"configureSegue" sender: self];
    } else {
        [self updateWelcomeLabel];
    }
    
 
}

- (void)setUserName:(NSString *)userName {
    _userName = userName;
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    [defaults setValue:userName forKey:@"userName"];
}

- (void)setUserPortrait:(NSString *)userPortrait {
    _userPortrait = userPortrait;
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    [defaults setValue:userPortrait forKey:@"userPortrait"];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"configureSegue"])
    {
        ConfigureViewController *vc = [segue destinationViewController];
        if (_userName) {
            [vc setUserName:_userName];            
        }
        [vc setMainViewController:self];
    }
    if ([[segue identifier] isEqualToString:@"chatSegue"])
    {
    
    }




}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) updateWelcomeLabel {
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    _userName = [defaults objectForKey:@"userName"];
    _userPortrait = [defaults objectForKey:@"userPortrait"];
    NSLog(@"%@",_userName);
    NSString *labelText = [NSString stringWithFormat:@"Welcome %@",_userName];
    [_welcomeLabel setText:labelText];
    self.portaitView.image = [UIImage imageNamed:_userPortrait];

}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *name = [[alertView textFieldAtIndex:0]text];
    self.userName = name;
    [self updateWelcomeLabel];
}




@end
