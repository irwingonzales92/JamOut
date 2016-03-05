//
//  SettingsViewController.m
//  ProjectJammix
//
//  Created by Irwin Gonzales on 2/27/16.
//  Copyright © 2016 Irwin Gonzales. All rights reserved.
//

#import "SettingsViewController.h"
#import <Parse/Parse.h>
#import "BackendFunctions.h"
#import "kColorConstants.h"

@interface SettingsViewController ()
@property (strong, nonatomic) IBOutlet UIButton *editProfileButton;
@property (strong, nonatomic) IBOutlet UIButton *contactUsButton;
@property (strong, nonatomic) IBOutlet UIButton *signoutButton;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavbar];
    [self setButtonColors];
}

- (void)setNavbar
{
    [BackendFunctions setupNavbarOnNavbar:self.navigationController onNavigationItem:self.navigationItem];
}

- (void)setButtonColors
{
    _editProfileButton.backgroundColor = [kColorConstants greenWithAlpha:1.0];
    _editProfileButton.titleLabel.textColor = [UIColor whiteColor];
    [_editProfileButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _signoutButton.backgroundColor = [kColorConstants greenWithAlpha:1.0];
    _signoutButton.titleLabel.textColor = [UIColor whiteColor];
    [_signoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _contactUsButton.backgroundColor = [kColorConstants greenWithAlpha:1.0];
    _contactUsButton.titleLabel.textColor = [UIColor whiteColor];
    [_contactUsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)editProfileOnButtonPressed:(id)sender
{
    
}

- (IBAction)contactUsOnButtonPressed:(id)sender
{
    
}

- (IBAction)signoutOnButtonPressed:(id)sender
{
    [BackendFunctions logOut];
    [self performSegueWithIdentifier:@"backToMainSegue" sender:sender];
}

#pragma
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}


@end
