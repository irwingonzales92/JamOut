//
//  SignupViewController.m
//  ProjectJammix
//
//  Created by Irwin Gonzales on 2/23/16.
//  Copyright © 2016 Irwin Gonzales. All rights reserved.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>
#import "BackendFunctions.h"
#import "RKDropdownAlert.h"
#import "kColorConstants.h"

@interface SignupViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmPassWordTextField;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

#define SEGUE_NAME @"signupToRootSegue"
#define USERNAME_ERROR_MESSAGE @"Did you fill in your username?"
#define PASSWORD_ERROR_MESSAGE @"Did you fill in your password?"
#define EMAIL_ERROR_MESSAGE @"Did you fill in your email?"

@end

@implementation SignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setDelegates];
    [self hideKeyboard];
    [self setButtonColors];
    
    _userNameTextField.placeholder = @"username";
    _emailTextField.placeholder = @"email";
    _passwordTextField.placeholder = @"password";
    _confirmPassWordTextField.placeholder = @"conform password";
    
    self.view.backgroundColor = [kColorConstants darkerBlueWithAlpha:1.0];
}

- (void)setDelegates
{
    _userNameTextField.delegate = self;
    _emailTextField.delegate = self;
    _passwordTextField.delegate = self;
    _confirmPassWordTextField.delegate = self;
}

- (void)hideKeyboard
{
    [_userNameTextField resignFirstResponder];
    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_confirmPassWordTextField resignFirstResponder];
    _passwordTextField.secureTextEntry = YES;
    _confirmPassWordTextField.secureTextEntry = YES;
}

- (void)setButtonColors
{
    _submitButton.backgroundColor = [kColorConstants greenWithAlpha:1.0];
    _submitButton.titleLabel.textColor = [UIColor whiteColor];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _cancelButton.backgroundColor = [kColorConstants greenWithAlpha:1.0];
    _cancelButton.titleLabel.textColor = [UIColor whiteColor];
    [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)signUpLogic
{
    if ([_userNameTextField.text isEqualToString:@""])
    {
        [RKDropdownAlert title:@"There was an error!" message:USERNAME_ERROR_MESSAGE backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1.0];
    }
    else if ([_emailTextField.text isEqualToString:@""])
    {
        [RKDropdownAlert title:@"There was an error!" message:EMAIL_ERROR_MESSAGE backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1.0];
    }
    else if ([_passwordTextField.text isEqualToString:@""])
    {
        [RKDropdownAlert title:@"There was an error!" message:PASSWORD_ERROR_MESSAGE backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1.0];
    }
    else if ([_confirmPassWordTextField.text isEqualToString:@""] && [_confirmPassWordTextField.text isEqualToString:_passwordTextField.text])
    {
        [RKDropdownAlert title:@"There was an error!" message:@"Your Passwords don't match" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1.0];
    }
    else
    {
        
        [BackendFunctions signupUserWithName:_userNameTextField.text
                                WithPassword:_passwordTextField.text
                             ConfirmPassword:_confirmPassWordTextField.text
                                    AndEmail:_emailTextField.text
                                onCompletion:^(BOOL success, NSError *error)
         {
             if (!error && success)
             {
                 if ([_confirmPassWordTextField.text isEqualToString:_passwordTextField.text])
                 {
                     NSLog(@"Signed up as %@", [PFUser currentUser].username);
                     [self performSegueWithIdentifier:SEGUE_NAME sender:self];
                 }
                 else
                 {
                     [RKDropdownAlert title:@"There was an error!" message:@"Your Passwords don't match" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1.0];
                 }
             }
             else
             {
                 [RKDropdownAlert title:@"There was an error!" message:error.localizedDescription backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1.0];
             }
         }];
    }

}

- (IBAction)signUpOnButtonPressed:(UIButton *)sender
{
    [self signUpLogic];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hideKeyboard];
    [self signUpLogic];
    return YES;
}

- (IBAction)backToInitalViewControllerOnButtonPressed:(UIButton *)sender
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
