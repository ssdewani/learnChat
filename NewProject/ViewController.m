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
#import "ChatService.h"
#import <MTBlockAlertView/MTBlockAlertView.h>


@interface ViewController  ()

@property (nonatomic, strong) NSMutableArray *dialogs;
@property (strong, nonatomic) QBUUser *currentUser;

@end

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.configureButton.enabled = NO;
    self.dialogsTableView.hidden = YES;
    NSUUID *identifierForVendor = [[UIDevice currentDevice] identifierForVendor];
    _uuid = [identifierForVendor UUIDString];
    [self createSession];
    }


-(void) enableMenus {
    self.configureButton.enabled = YES;
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    if ((![defaults objectForKey:@"userName"])||(![defaults objectForKey:@"userPortrait"])) {
        [self performSegueWithIdentifier: @"configureSegue" sender: self];
    }
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

- (void)setUuid:(NSString *)uuid {
    _uuid = uuid;
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    [defaults setValue:uuid forKey:@"userID"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"configureSegue"]) {
        ConfigureViewController *vc = [segue destinationViewController];
        if (_userName) {
            [vc setUserName:_userName];            
        }
        [vc setMainViewController:self];
    } else if ([[segue identifier] isEqualToString:@"chatSegue"]) {
        ChatViewController *vc = [segue destinationViewController];
        NSString *chatRoomJID = [self.dialogs[((UITableViewCell *)sender).tag] roomJID];
        vc.chatRoomJID = chatRoomJID;
        vc.currentUserID = (int) _currentUser.ID;
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



#pragma mark - UI table view callbacks

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dialogs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatRoomCellIdentifier"];
    QBChatDialog *chatDialog = self.dialogs[indexPath.row];
    cell.tag  = indexPath.row;
    cell.textLabel.text = chatDialog.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - QBChat stuff

- (void) createSession {
    
    _currentUser = [QBUUser user];
    _currentUser.login = _uuid;
    _currentUser.password = _uuid;
    
    
    [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session) {
        [QBRequest usersWithLogins:@[_uuid] page:[QBGeneralResponsePage responsePageWithCurrentPage:1 perPage:10]
                   successBlock:^(QBResponse *response, QBGeneralResponsePage *page, NSArray *users) {
                       if (users.count ==0) {
                           [QBRequest signUp:_currentUser successBlock:^(QBResponse *response, QBUUser *user) {
                               // Success, do something
                               NSLog(@"yippee");
                               [QBRequest logInWithUserLogin:_currentUser.login password:_currentUser.password
                                                successBlock:^(QBResponse *response, QBUUser *user) {
                                   // Success, do something
                                                    _currentUser.ID = user.ID;
                                                    [[ChatService instance] loginWithUser:_currentUser completionBlock:^{
                                                        [self requestChatGroups];
                                                    }];

                                                    
                               } errorBlock:^(QBResponse *response) {
                                   // error handling
                                   NSLog(@"error: %@", response.error);
                               }];
                           } errorBlock:^(QBResponse *response) {
                               // error handling
                               NSLog(@"error: %@", response.error);
                           }];
                       } else {
                           [QBRequest logInWithUserLogin:_currentUser.login password:_currentUser.password
                                            successBlock:^(QBResponse *response, QBUUser *user) {
                                                _currentUser.ID = user.ID;
                                                [[ChatService instance] loginWithUser:_currentUser completionBlock:^{
                                                    [self requestChatGroups];
                                                }];
                                                // Success, do something
                                            } errorBlock:^(QBResponse *response) {
                                                // error handling
                                                NSLog(@"error: %@", response.error);
                                            }];
                       }
                   } errorBlock:^(QBResponse *response) {
 
                   }];
    
    } errorBlock:^(QBResponse *response) {
        NSLog(@"error: %@",response);
    }];
    
    
}





- (void) requestChatGroups {
    NSMutableDictionary *extendedRequest = [NSMutableDictionary new];
    extendedRequest[@"limit"] = @(100);
    //extendedRequest[@"skip"] = @(100);
    [QBChat dialogsWithExtendedRequest:extendedRequest delegate:self];
}

- (void)completedWithResult:(Result *)result{
    if (result.success && [result isKindOfClass:[QBDialogsPagedResult class]]) {
        QBDialogsPagedResult *pagedResult = (QBDialogsPagedResult *)result;
        NSArray *dialogs = pagedResult.dialogs;
        NSLog(@"Dialogs: %@", dialogs);
        
        self.dialogs = [dialogs mutableCopy];
        self.dialogsTableView.hidden = NO;
        [self.dialogsTableView reloadData];
        [self enableMenus];
    }
}




@end
