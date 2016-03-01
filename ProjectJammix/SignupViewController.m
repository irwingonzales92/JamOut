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
    [self setTextfieldDesign];
    self.view.backgroundColor = [kColorConstants darkerBlueWithAlpha:1.0];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
}

//-------------------------------------------------- CLASS ACTIONS ----------------------------------------------------------------

- (IBAction)signUpOnButtonPressed:(UIButton *)sender
{
    [self signUpLogic];
}

#pragma
#pragma mark - Navigation
- (IBAction)backToInitalViewControllerOnButtonPressed:(UIButton *)sender
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

//-------------------------------------------------- HELPER METHODS-----------------------------------------------------------------

#pragma
#pragma mark - Setup
- (void)setDelegates
{
    _userNameTextField.delegate = self;
    _emailTextField.delegate = self;
    _passwordTextField.delegate = self;
    _confirmPassWordTextField.delegate = self;
}


#pragma
#pragma mark - Button Stuff
- (void)setButtonColors
{
    [BackendFunctions buttonSetupWithButton:_submitButton];
    
    [BackendFunctions buttonSetupWithButton:_cancelButton];
}


#pragma
#pragma mark - Textfield Stuff
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _userNameTextField )
    {
        [_userNameTextField resignFirstResponder];
        [_emailTextField becomeFirstResponder];
    }
    else if (textField == _emailTextField)
    {
        [_emailTextField resignFirstResponder];
        [_passwordTextField becomeFirstResponder];
    }
    else if (textField == _passwordTextField)
    {
        [_passwordTextField resignFirstResponder];
        [_confirmPassWordTextField becomeFirstResponder];
    }
    else if (textField == _confirmPassWordTextField)
    {
        [self hideKeyboard];
        [self signUpLogic];
    }
    return YES;
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

- (void)setTextfieldDesign
{
    //TextField Design
    [BackendFunctions textfieldSetupWithTextfield:_userNameTextField andPlaceholderText:@"Username"];
    
    [BackendFunctions textfieldSetupWithTextfield:_emailTextField andPlaceholderText:@"Email"];
    
    [BackendFunctions textfieldSetupWithTextfield:_passwordTextField andPlaceholderText:@"Password"];
    
    [BackendFunctions textfieldSetupWithTextfield:_confirmPassWordTextField andPlaceholderText:@"Confirm Password"];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_userNameTextField.isEditing)
    {
        _userNameTextField.placeholder = nil;
    }
    else if (_passwordTextField.isEditing)
    {
        _passwordTextField.placeholder = nil;
    }
    else if (_emailTextField.isEditing)
    {
        _emailTextField.placeholder = nil;
    }
    else if (_confirmPassWordTextField.isEditing)
    {
        _confirmPassWordTextField.placeholder = nil;
    }
}

#pragma
#pragma mark - Signup Logic 
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

#pragma
#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
