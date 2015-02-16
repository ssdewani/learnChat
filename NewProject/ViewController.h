//
//  ViewController.h
//  NewProject
//
//  Created by Salim Dewani on 11/18/14.
//  Copyright (c) 2014 Salim Dewani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate,QBActionStatusDelegate, QBChatDelegate>

@property (nonatomic,copy) NSString *uuid;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *userPortrait;
@property (nonatomic,copy) NSString *favoriteTeam;

@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *portaitView;
@property (weak, nonatomic) IBOutlet UIButton *configureButton;
@property (weak, nonatomic) IBOutlet UITableView *dialogsTableView;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

