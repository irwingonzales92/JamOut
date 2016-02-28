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
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor blackColor],
                                                                       NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:20.0f]                                                                      }];
    [self.navigationController.navigationBar setBackgroundColor:[kColorConstants darkerBlueWithAlpha:1.0]];
    [self.navigationItem setTitle: @"Jammout"];
    
    self.view.backgroundColor = [kColorConstants darkerBlueWithAlpha:1.0];
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
