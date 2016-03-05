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
#import "BackendFunctions.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

@interface InitialViewController () <MPMediaPickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *signupButton;
@property (strong, nonatomic) UIImage *imageFile;
//@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerViewController *avPlayerViewcontroller;


@end

@implementation InitialViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setButtonColors];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [kColorConstants darkerBlueWithAlpha:1.0];
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"output_3NM46H" ofType:@"gif"];
    NSData *gif = [NSData dataWithContentsOfFile:filePath];
    
    UIWebView *webViewBG = [[UIWebView alloc] initWithFrame:self.view.frame];
    [webViewBG loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    webViewBG.userInteractionEnabled = NO;
    [self.view addSubview:webViewBG];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 
#pragma mark - Button Setup
- (void)setButtonColors
{
    [BackendFunctions buttonSetupWithButton:_loginButton];
    [BackendFunctions buttonSetupWithButton:_signupButton];
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
