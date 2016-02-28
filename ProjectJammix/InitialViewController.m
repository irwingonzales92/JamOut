//
//  InitialViewController.m
//  ProjectJammix
//
//  Created by Irwin Gonzales on 2/23/16.
//  Copyright © 2016 Irwin Gonzales. All rights reserved.
//

#import "InitialViewController.h"
#import <Parse/Parse.h>
#import "kColorConstants.h"

@interface InitialViewController ()
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *signupButton;
@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) UIImage *imageFile;

@end

@implementation InitialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setButtonColors];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [kColorConstants darkerBlueWithAlpha:1.0];
    
    _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 360, 235)];
    _logoImageView.image = [UIImage imageNamed:@"smaller"];
    [self.view addSubview:_logoImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setButtonColors
{
    _loginButton.backgroundColor = [kColorConstants greenWithAlpha:1.0];
    _loginButton.titleLabel.textColor = [UIColor whiteColor];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _signupButton.backgroundColor = [kColorConstants greenWithAlpha:1.0];
    _signupButton.titleLabel.textColor = [UIColor whiteColor];
    [_signupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

#pragma 
#pragma mark - Button Actions
- (IBAction)segueToLoginViewControllerOnButtonPressed:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"toSignupSegue" sender:sender];
}

- (IBAction)segueToSignUpViewControllerOnButtonPressed:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"toLoginSegue" sender:sender];
}
#pragma
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
