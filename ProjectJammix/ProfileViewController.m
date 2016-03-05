//
//  ProfileViewController.m
//  ProjectJammix
//
//  Created by Irwin Gonzales on 2/23/16.
//  Copyright © 2016 Irwin Gonzales. All rights reserved.
//

#import "ProfileViewController.h"
#import "kColorConstants.h"
#import <AVFoundation/AVFoundation.h>
#import "BackendFunctions.h"
#import "ProfileSongTableViewCell.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate, AVAudioSessionDelegate>
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIButton *followButton;
@property (strong, nonatomic) NSArray *songArray;
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstnameLabel;
@property (strong, nonatomic) IBOutlet UILabel *lLabel;
@property (strong, nonatomic) IBOutlet UILabel *songPostedLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *songCountLabel;
@property (strong, nonatomic) UIImage *imageFile;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) AVAudioSession *audioSession;

@property (strong, nonatomic) PFObject *song;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self querySongs];
    [self setImageViewBorder];
    [self setLabelColors];
    [self setButtonColors];
    [self setDelegates];
    [self setNavbar];
    
    self.view.backgroundColor = [kColorConstants darkerBlueWithAlpha:1.0];
    _topView.backgroundColor = [kColorConstants darkBlueWithAlpha:1.0];
    
    PFUser *user = [PFUser currentUser];
    
//    _firstnameLabel.text = user[@"firstName"];
    [_firstnameLabel setText:[NSString stringWithFormat:@"%@ %@",user[@"firstName"],user[@"lastName"]]];
    _usernameLabel.text = user[@"username"];
    _locationLabel.text = user[@"location"];
    [_songCountLabel setText:[NSString stringWithFormat:@"%@", [user[@"songCount"] stringValue]]];
    
    PFFile *songPhoto = [user objectForKey:@"profileImage"];
    [songPhoto getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error)
     {
         if (!error)
         {
             _imageFile = [UIImage imageWithData:data];
             _userImageView.image = _imageFile;
         }
         else
         {
             NSLog(@"Something Went Wrong %@",error.localizedDescription);
         }
     }];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_audioPlayer stop];
}

- (void)setDelegates
{
    _audioPlayer.delegate = self;
    _audioSession = [AVAudioSession sharedInstance];
    _audioPlayer.numberOfLoops = 2;
}

- (void)setNavbar
{
    [BackendFunctions setupNavbarOnNavbar:self.navigationController onNavigationItem:self.navigationItem];
}

- (void)setButtonColors
{
    _playButton.backgroundColor = [kColorConstants greenWithAlpha:1.0];
    _playButton.titleLabel.textColor = [UIColor whiteColor];
    [_playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _followButton.backgroundColor = [kColorConstants greenWithAlpha:1.0];
     _followButton.titleLabel.textColor = [UIColor whiteColor];
    [ _followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setLabelColors
{
    [_usernameLabel setTextColor:[UIColor whiteColor]];
    [_firstnameLabel setTextColor:[UIColor whiteColor]];
    [_locationLabel setTextColor:[UIColor whiteColor]];
    [_songCountLabel setTextColor:[UIColor whiteColor]];
    [_lLabel setTextColor:[UIColor whiteColor]];
    [_songPostedLabel setTextColor:[UIColor whiteColor]];
}

- (void)setImageViewBorder
{
    [_userImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [_userImageView.layer setBorderWidth:4.3]; // For Border width
    [_userImageView.layer setCornerRadius:45.0f]; // For Corner radious
    [_userImageView.layer setMasksToBounds:YES];
}

- (void)querySongs
{
    [BackendFunctions querySongsFromUser:[PFUser currentUser] WithArray:^(NSArray *array, NSError *error)
    {
        if (!error)
        {
            _songArray = array;
            [_tableView reloadData];
        }
        else
        {
            NSLog(@"Error %@",error.localizedDescription);
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _songArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    _song = [_songArray objectAtIndex:indexPath.row];
    PFFile *songPhoto = [_song objectForKey:@"image"];
    [songPhoto getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error)
     {
         if (!error)
         {
             _imageFile = [UIImage imageWithData:data];
             cell.songImage.image = _imageFile;
//             [cell.customImageView.layer setBorderColor:[[UIColor whiteColor]CGColor]];
//             [cell.customImageView.layer setBorderWidth:1.3];
//             [cell.customImageView.layer setCornerRadius:5.0f];
//             [cell.customImageView.layer setMasksToBounds:YES];
         }
         else
         {
             NSLog(@"Something Went Wrong %@",error.localizedDescription);
         }
     }];

    
    cell.songTitleLabel.text = _song[@"title"];
    cell.songTitleLabel.textColor = [kColorConstants darkBlueWithAlpha:1.0];
    [cell.songTitleLabel setFont:[UIFont fontWithName:@"Avenir" size:20]];
    [ProfileSongTableViewCell setStyleingWithCell:cell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _song = [_songArray objectAtIndex:indexPath.row];
    [self playObject:_song[@"title"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playSongOnButtonPressed:(id)sender
{
    if (!_audioPlayer.isPlaying)
    {
        [self playLogic];
        [_playButton setTitle:@"Stop" forState:UIControlStateNormal];
    }
    else
    {
        [_audioPlayer pause];
        [_playButton setTitle:@"Play" forState:UIControlStateNormal];
    }
}

- (void)playLogic
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

- (void)playObject:(NSString *)object
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Song"];
    [query whereKey:@"title" equalTo:object];
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

- (IBAction)requestCollaborationOnButtonPressed:(id)sender
{
    
}

#pragma
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
