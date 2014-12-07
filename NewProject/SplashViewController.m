//
//  SplashViewController.m
//  NewProject
//
//  Created by Salim Dewani on 11/29/14.
//  Copyright (c) 2014 Salim Dewani. All rights reserved.
//

#import "SplashViewController.h"
#import <Quickblox/Quickblox.h>

@interface SplashViewController ()



@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    NSUUID *identifierForVendor = [[UIDevice currentDevice] identifierForVendor];
    NSString *uuid = [identifierForVendor UUIDString];
    
    if (![defaults objectForKey:@"userID"]) {
        [self signUpForChat:uuid];
    } else {
        [self performSegueWithIdentifier: @"startSegue" sender: self];
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
            [self performSegueWithIdentifier: @"startSegue" sender: self];
        } errorBlock:^(QBResponse *response) {
            // error handling
            NSLog(@"error: %@", [response.error description]);
            [self performSegueWithIdentifier: @"startSegue" sender: self];
        }];
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"error: %@", response.error);
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
