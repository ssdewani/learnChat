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
    [super viewDidLoad];
    self.chatButton.enabled = NO;
    self.configureButton.enabled = NO;
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    NSUUID *identifierForVendor = [[UIDevice currentDevice] identifierForVendor];
    NSString *uuid = [identifierForVendor UUIDString];
    
    if (![defaults objectForKey:@"userID"]) {
        [self signUpForChat:uuid];
    } else {
        [self enableMenus];
    }
}

-(void) enableMenus {
    self.chatButton.enabled = YES;
    self.configureButton.enabled = YES;
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    if ((![defaults objectForKey:@"userName"])||(![defaults objectForKey:@"userPortrait"])) {
        [self performSegueWithIdentifier: @"configureSegue" sender: self];
    }
}

- (void) signUpForChat:(NSString *) uuid {
    
    QBUUser *user = [QBUUser user];
    user.password = uuid;
    user.login = uuid;
    
    [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session) {
        NSLog(@"success");
        [QBRequest signUp:user successBlock:^(QBResponse *response, QBUUser *user) {
            // Success, do something
            NSLog(@"yooho %@",uuid);
            NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
            [defaults setObject:uuid forKey:@"userID"];
            [self enableMenus];
        } errorBlock:^(QBResponse *response) {
            // error handling
            NSLog(@"error: %@", [response.error description]);
            [self enableMenus];
        }];
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"error: %@", response.error);
    }];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self updateWelcomeLabel];
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
