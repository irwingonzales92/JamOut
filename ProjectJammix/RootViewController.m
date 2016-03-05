//
//  ViewController.m
//  ProjectJammix
//
//  Created by Irwin Gonzales on 2/23/16.
//  Copyright © 2016 Irwin Gonzales. All rights reserved.
//

#import "RootViewController.h"
#import <Parse/Parse.h>
#import "BackendFunctions.h"
#import "MediaPlayerViewController.h"
#import "SongTableViewCell.h"
#import "kColorConstants.h"

@interface RootViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *userArray;
@property (strong, nonatomic) NSArray *songArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) PFObject *songs;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UIImage *imageFile;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self querySongs];
    [self setTableViewColor];
    [self setNavbar];
    [self useRefreshControl];
    
    self.view.backgroundColor = [kColorConstants darkerBlueWithAlpha:1.0];
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(reloadTableView) userInfo:nil repeats:YES];
}

- (void)setNavbar
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor blackColor],
                                                                       NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:20.0f]                                                                      }];
    [self.navigationController.navigationBar setBackgroundColor:[kColorConstants darkerBlueWithAlpha:1.0]];
    [self.navigationItem setTitle: @"Jammout"];
}


- (void)setTableViewColor
{
    [BackendFunctions setupTableView:_tableView];
}

- (void)useRefreshControl
{
    _refreshControl = [UIRefreshControl new];
    _refreshControl.backgroundColor = [kColorConstants darkerBlueWithAlpha:1.0];
    _refreshControl.tintColor = [UIColor whiteColor];
    [_tableView addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(querySongs) forControlEvents:UIControlEventValueChanged];
}

- (void)querySongs
{
    [BackendFunctions songArrayQuery:^(NSArray *array, NSError *error)
    {
        if (!error)
        {
            _songArray = array;
            [_tableView reloadData];
            [_refreshControl endRefreshing];
        }
        else
        {
            NSLog(@"%@",error.localizedDescription);
        }
    }];
}

- (void)reloadTableView
{
    [_tableView reloadData];
    [_refreshControl endRefreshing];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    _songs = [_songArray objectAtIndex:indexPath.row];
    cell.songLabel.text = _songs[@"title"];
    cell.songLabel.textColor = [UIColor whiteColor];
    [cell.songLabel setFont:[UIFont fontWithName:@"Avenir" size:20]];
    cell.artistLabel.text = _songs[@"artist"];
    cell.artistLabel.textColor = [UIColor whiteColor];
    [cell.artistLabel setFont:[UIFont fontWithName:@"Avenir" size:15]];
    cell.backgroundColor = [kColorConstants darkBlueWithAlpha:1.0];
    
    PFFile *songPhoto = [_songs objectForKey:@"image"];
    [songPhoto getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error)
     {
         if (!error)
         {
             _imageFile = [UIImage imageWithData:data];
             cell.customImageView.image = _imageFile;
             [cell.customImageView.layer setBorderColor:[[UIColor blackColor]CGColor]];
             [cell.customImageView.layer setBorderWidth:1.3];
             [cell.customImageView.layer setCornerRadius:5.0f];
             [cell.customImageView.layer setMasksToBounds:YES];
         }
         else
         {
             NSLog(@"Something Went Wrong %@",error.localizedDescription);
         }
     }];
    
    [SongTableViewCell setStyleingWithCell:cell];

    return cell;
}


// Parallax Effect On TableView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Get visible cells on table view.
    NSArray *visibleCells = [self.tableView visibleCells];
    
    for (SongTableViewCell *cell in visibleCells) {
        [cell cellOnTableView:self.tableView didScrollOnView:self.view];
    }
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *song = _songArray[indexPath.row];
    [self performSegueWithIdentifier:@"toMediaPlayerSegue" sender:song];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _songArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PFObject *song = (PFObject *)sender;
    MediaPlayerViewController *vc = [segue destinationViewController];
    NSLog(@"passed song");
    vc.song = song;
}

@end
