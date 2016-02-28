//
//  LoginViewController.m
//  ProjectJammix
//
//  Created by Irwin Gonzales on 2/23/16.
//  Copyright © 2016 Irwin Gonzales. All rights reserved.
//

#import "LoginViewController.h"
#import "BackendFunctions.h"
#import "RKDropdownAlert.h"
#import <Parse/Parse.h>
#import "kColorConstants.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

#define SEGUE_NAME @"loginToRootSegue"
#define USERNAME_ERROR_MESSAGE @"Did you fill in your username?"
#define PASSWORD_ERROR_MESSAGE @"Did you fill in your password?"

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setButtonColors];
    [self hideKeyboard];
    [self setDelegates];
    self.view.backgroundColor = [kColorConstants darkerBlueWithAlpha:1.0];
    
    _usernameTextField.placeholder = @"username";
    _passwordTextField.placeholder = @"password";
}

- (void)hideKeyboard
{
    [_usernameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    _passwordTextField.secureTextEntry = YES;
}

- (void)setDelegates
{
    _usernameTextField.delegate = self;
    _passwordTextField.delegate = self;
}

- (void)setButtonColors
{
    _loginButton.backgroundColor = [kColorConstants greenWithAlpha:1.0];
    _loginButton.titleLabel.textColor = [UIColor whiteColor];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _cancelButton.backgroundColor = [kColorConstants greenWithAlpha:1.0];
    _cancelButton.titleLabel.textColor = [UIColor whiteColor];
    [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)logInOnButtonPressed:(UIButton *)sender
{
    [self hideKeyboard];
    [self loginLogic];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hideKeyboard];
    [self loginLogic];
    return YES;
}

- (void)loginLogic
{
    if ([_usernameTextField.text isEqualToString:@""])
    {
        [RKDropdownAlert title:@"There was an error!" message:USERNAME_ERROR_MESSAGE backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1.0];
    }
    else if ([_passwordTextField.text isEqualToString:@""])
    {
        [RKDropdownAlert title:@"There was an error!" message:PASSWORD_ERROR_MESSAGE backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1.0];
    }
    else
    {
        [BackendFunctions loginUserWithUsername:_usernameTextField.text AndPassword:_passwordTextField.text onCompletion:^(BOOL success, NSError *error)
         {
             if (!error && success)
             {
                 NSLog(@"Signed In As %@", [PFUser currentUser].username);
                 [self performSegueWithIdentifier:SEGUE_NAME sender:self];
             }
             else
             {
                 [RKDropdownAlert title:@"There was an error!" message:error.localizedDescription backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1.0];
             }
         }];
    }
}

- (IBAction)didCancelOnButtonPressed:(id)sender
{
    
}

#pragma
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
