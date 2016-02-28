//
//  ChatViewController.m
//  ProjectJammix
//
//  Created by Irwin Gonzales on 2/26/16.
//  Copyright © 2016 Irwin Gonzales. All rights reserved.
//

#import "ChatViewController.h"
#import "BackendFunctions.h"
#import <Parse/Parse.h>
#import "kColorConstants.h"
#import "MessageTableViewCell.h"

@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) PFUser *invitedUser;
@property (strong, nonatomic) NSArray *messageArray;
@property (strong, nonatomic) PFObject *message;

@end

@implementation ChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavbar];
    [self queryMessages];
    [self setDelegates];
    [self setButtonColors];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(queryMessages) userInfo:nil repeats:YES];
}

- (void)setButtonColors
{
    _sendButton.backgroundColor = [kColorConstants greenWithAlpha:1.0];
    _sendButton.titleLabel.textColor = [UIColor whiteColor];
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)queryMessages
{
    [BackendFunctions messageQueryWithInviteId:_invite onReturnArray:^(NSArray *array, NSError *error)
    {
        if (!error)
        {
            _messageArray = array;
            [_tableView reloadData];
        }
        else
        {
            NSLog(@"%@",error.localizedDescription);
        }
    }];
}

-(void)setDelegates
{
    _textField.delegate = self;
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

- (void)setNavbar
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor blackColor],
                                                                       NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:20.0f]                                                                      }];
    [self.navigationController.navigationBar setBackgroundColor:[kColorConstants darkerBlueWithAlpha:1.0]];
    [self.navigationItem setTitle: @"Jammout"];
    
    self.view.backgroundColor = [kColorConstants darkerBlueWithAlpha:1.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    _message = [_messageArray objectAtIndex:indexPath.row];
    
    _invitedUser = [PFUser user];
    //cell.textLabel.text = _message[@"message"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@  -%@",_message[@"message"],_message[@"senderName"]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Avenir" size:20]];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messageArray.count;
}
- (IBAction)sendMessageOnButtonPressed:(id)sender
{
    [_textField resignFirstResponder];
    [self signupLogic];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_textField resignFirstResponder];
    [self signupLogic];
    return YES;
}

- (void)signupLogic
{
    _message = [PFObject objectWithClassName:@"Message"];
    _message[@"message"] = _textField.text;
    _message[@"sender"] = _invite[@"receiver"];
    _message[@"receiver"] = _invite[@"sender"];
    _message[@"invite"] = _invite;
    _message[@"senderName"] = @"irwin";
    NSLog(@"%@", _message[@"senderName"]);
    [_message saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
     {
         if (!error && succeeded)
         {
             NSLog(@"Message Sent");
         }
         else
         {
             NSLog(@"Something Went Wrong %@",error.localizedDescription);
         }
     }];
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
