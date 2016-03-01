//
//  CollabMediaViewController.m
//  ProjectJammix
//
//  Created by Irwin Gonzales on 2/27/16.
//  Copyright © 2016 Irwin Gonzales. All rights reserved.
//

#import "CollabMediaViewController.h"
#import "ChatViewController.h"
#import <Parse/Parse.h>
#import <AVFoundation/AVFoundation.h>
#import "BackendFunctions.h"
#import "kColorConstants.h"


@interface CollabMediaViewController () <AVAudioPlayerDelegate, AVAudioSessionDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) AVAudioSession *audioSession;
@property (strong, nonatomic) NSURL *documents;
@property (strong, nonatomic) NSURL *filePath;
@property (strong, nonatomic) UIAlertController *alert;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIImageView *songImageView;
@property (strong, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *senderNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *senderLabel;
@property (strong, nonatomic) IBOutlet UISlider *seekBar;
@property (nonatomic, strong) NSTimer *updateTimer;
@property (strong, nonatomic) IBOutlet UIButton *declineButton;
@property (strong, nonatomic) IBOutlet UIButton *acceptButton;


@property (strong, nonatomic) PFFile *audioFile;

@end

@implementation CollabMediaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavbar];
    [self buttonStyling];
    
    self.view.backgroundColor = [kColorConstants darkerBlueWithAlpha:1.0];
    self.seekBar.minimumValue = 0;
    
    self.seekBar.maximumValue = self.audioPlayer.duration;
    
    [[self audioPlayer] play];
    
    self.updateTimer =     [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateSeekBar) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_audioPlayer stop];
}

- (void)setNavbar
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor blackColor],
                                                                       NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:20.0f]                                                                      }];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blueColor]];
    [self.navigationItem setTitle: @"Jammout"];
}

- (void)buttonStyling
{
    [BackendFunctions buttonSetupWithButton:_playButton];
    [BackendFunctions buttonSetupWithButton:_acceptButton];
    [BackendFunctions buttonSetupWithButton:_declineButton];
}

- (void)setDelegates
{
    _audioPlayer.delegate = self;
    _audioSession = [AVAudioSession sharedInstance];
    _audioPlayer.numberOfLoops = 2;
}
- (IBAction)seekTime:(id)sender
{
    self.audioPlayer.currentTime = self.seekBar.value;
}

- (void)updateSeekBar{
    float progress = self.audioPlayer.currentTime;
    [self.seekBar setValue:progress];
}

- (void)playFile
{
    PFQuery *query = [PFQuery queryWithClassName:@"Song"];
    [query whereKey:@"title" equalTo:_song[@"title"]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The Audio file could not be found, request failed.");
        } else {
            // The find succeeded.
            // NSLog(@"Successfully retrieved the Audio File.");
            PFFile *audioFile = object[@"audio"];
            
            [audioFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                NSError *playerError = nil;
                self.audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
                if (playerError)
                {
                    NSLog(@"There was an error reading the audio file: %@", error);
                }
                else
                {
                    self.audioPlayer.delegate = self;
                    [self.audioPlayer prepareToPlay];
                    [self.audioPlayer setVolume:0.5];
                    self.audioPlayer.numberOfLoops = 0;
                    [self.audioPlayer play];
                }
            }];
        }
    }];
}
- (IBAction)playOrStopMusicOnButtonPressed:(UIButton *)sender
{
    if (!_audioPlayer.isPlaying)
    {
        [self playFile];
        [_playButton setTitle:@"Stop" forState:UIControlStateNormal];
    }
    else
    {
        [_audioPlayer pause];
        [_playButton setTitle:@"Play" forState:UIControlStateNormal];
    }

}
- (IBAction)declineCollabOnButtonPressed:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are You Sure You Want To Decline?"
                                                                   message:@"Deleting This Would Erase It Forever"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action)
    {
        [self performSelector:@selector(declineCollabLogic)];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Nevermind" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
    {
        nil;
    }];
    
    [alert addAction:yes];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (IBAction)acceptCollabOnButtonPressed:(id)sender
{
    [_invite setValue:[NSNumber numberWithBool:true] forKey:@"accepted"];
    [_invite saveInBackground];
    [self performSegueWithIdentifier:@"toChatSegue" sender:self];
}

- (void)declineCollabLogic
{
    [_invite setValue:[NSNumber numberWithBool:false] forKey:@"accepted"];
    [_invite delete];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ChatViewController *vc = [segue destinationViewController];
    vc.invite = _invite;
    
}


@end
