//
//  MediaPlayerViewController.m
//  ProjectJammix
//
//  Created by Irwin Gonzales on 2/25/16.
//  Copyright © 2016 Irwin Gonzales. All rights reserved.
//

#import "MediaPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SongListViewController.h"
#import "JGActionSheet.h"
#import "BackendFunctions.h"
#import <Parse/Parse.h>
#import "EZAudio.h"
#import "kColorConstants.h"

@interface MediaPlayerViewController () <AVAudioPlayerDelegate, AVAudioSessionDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) AVAudioSession *audioSession;
@property (strong, nonatomic) NSURL *documents;
@property (strong, nonatomic) NSURL *filePath;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIButton *collabButton;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *artistLabel;
@property (strong, nonatomic) IBOutlet UILabel *genreLabel;
@property (strong, nonatomic) UIAlertController *alert;
@property (strong, nonatomic) IBOutlet UILabel *stitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *aLabel;
@property (strong, nonatomic) IBOutlet UILabel *glabel;
@property (strong, nonatomic) IBOutlet UISlider *seekBar;
@property (nonatomic, strong) NSTimer *updateTimer;

@property (strong, nonatomic) PFFile *audioFile;
@property (strong, nonatomic) UIImage *imageFile;

@end

@implementation MediaPlayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setDelegates];
    [self querySongImage];
    [self setButtonColors];
    [self setLabels];
    [self setNavbar];
    [self setLabelColors];
    
    self.view.backgroundColor = [kColorConstants darkerBlueWithAlpha:1.0];
    
    self.seekBar.minimumValue = 0;
    
    self.seekBar.maximumValue = self.audioPlayer.duration;
    
    self.updateTimer =     [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateSeekBar) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_audioPlayer stop];
}

- (void)updateSeekBar
{
    float progress = self.audioPlayer.currentTime;
    [self.seekBar setValue:progress];
}
- (IBAction)seekTime:(id)sender
{
    self.audioPlayer.currentTime = self.seekBar.value;
}

- (void)setNavbar
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor blackColor],
                                                                       NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:20.0f]                                                                      }];
    [self.navigationController.navigationBar setBackgroundColor:[kColorConstants darkerBlueWithAlpha:1.0]];
    [self.navigationItem setTitle: @"Jammout"];
}

- (void)setButtonColors
{
    _playButton.backgroundColor = [kColorConstants greenWithAlpha:1.0];
    _playButton.titleLabel.textColor = [UIColor whiteColor];
    [_playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _collabButton.backgroundColor = [kColorConstants greenWithAlpha:1.0];
    _collabButton.titleLabel.textColor = [UIColor whiteColor];
    [_collabButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setDelegates
{
    _audioPlayer.delegate = self;
    _audioSession = [AVAudioSession sharedInstance];
    _audioPlayer.numberOfLoops = 2;
}

- (void)setLabels
{
    _songTitleLabel.text = _song[@"title"];
    _artistLabel.text = _song[@"artist"];
    _genreLabel.text = _song[@"genre"];
}

- (void)setLabelColors
{
    [_songTitleLabel setTextColor:[kColorConstants darkBlueWithAlpha:1.0]];
    [_songTitleLabel setFont:[UIFont fontWithName:@"Avenir" size:17]];
    [_artistLabel setTextColor:[kColorConstants darkBlueWithAlpha:1.0]];
    [_artistLabel setFont:[UIFont fontWithName:@"Avenir" size:17]];
    [_genreLabel setTextColor:[kColorConstants darkBlueWithAlpha:1.0]];
    [_genreLabel setFont:[UIFont fontWithName:@"Avenir" size:17]];
    [_stitleLabel setTextColor:[kColorConstants darkBlueWithAlpha:1.0]];
    [_stitleLabel setFont:[UIFont fontWithName:@"Avenir" size:17]];
    [_aLabel setTextColor:[kColorConstants darkBlueWithAlpha:1.0]];
    [_aLabel setFont:[UIFont fontWithName:@"Avenir" size:17]];
    [_glabel setTextColor:[kColorConstants darkBlueWithAlpha:1.0]];
    [_glabel setFont:[UIFont fontWithName:@"Avenir" size:17]];
}

- (void)playFile
{
    PFQuery *query = [PFQuery queryWithClassName:@"Song"];
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

- (void)querySongImage
{
    PFFile *songPhoto = [_song objectForKey:@"image"];
    [songPhoto getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error)
    {
        if (!error)
        {
            _imageFile = [UIImage imageWithData:data];
            _imageView.image = _imageFile;
        }
        else
        {
            NSLog(@"Something Went Wrong %@",error.localizedDescription);
        }
    }];
}

- (void)playOrStopMediaPlayer
{
    if (_audioPlayer.isPlaying)
    {
        [[AVAudioSession sharedInstance] setActive: NO error: nil];
    }
    else
    {
        [_audioPlayer stop];
        [[AVAudioSession sharedInstance] setActive: NO error: nil];

    }
}
- (IBAction)playSongOrStopSongOnButtonPressed:(UIButton *)sender
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)requestCollabOnButtonPressed:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"toSongListSegue" sender:_song];
}

#pragma
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SongListViewController *vc = [segue destinationViewController];
    vc.song = _song;
}


@end
