//
//  CollabRequestViewController.m
//  ProjectJammix
//
//  Created by Irwin Gonzales on 2/26/16.
//  Copyright © 2016 Irwin Gonzales. All rights reserved.
//

#import "CollabRequestViewController.h"
#import "BackendFunctions.h"
#import "CollabMediaViewController.h"
#import "ChatViewController.h"
#import <Parse/Parse.h>
#import "kColorConstants.h"
#import "MessageTableViewCell.h"


@interface CollabRequestViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *inviteArray;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UIViewController *chatViewController;
@property (strong, nonatomic) PFObject *invite;
@property (strong, nonatomic) UIImage *imageFile;

@end

@implementation CollabRequestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self inviteQuery];
    [self setNavbar];
    [self useRefreshControl];
    
}

- (void)setNavbar
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor blackColor],
                                                                       NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:20.0f]                                                                      }];
    [self.navigationController.navigationBar setBackgroundColor:[kColorConstants darkerBlueWithAlpha:1.0]];
    [self.navigationItem setTitle: @"Jammout"];
    
    self.view.backgroundColor = [kColorConstants darkerBlueWithAlpha:1.0];
}


- (void)inviteQuery
{
    [BackendFunctions inviteQuery:^(NSArray *array, NSError *error)
    {
        _inviteArray = array;
        [self.tableView reloadData];
        [_refreshControl endRefreshing];
    }];
}

- (void)reloadTableView
{
    [_tableView reloadData];
    [_refreshControl endRefreshing];
}

- (void)useRefreshControl
{
    _refreshControl = [UIRefreshControl new];
    _refreshControl.backgroundColor = [UIColor grayColor];
    _refreshControl.tintColor = [UIColor whiteColor];
    [_tableView addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(inviteQuery) forControlEvents:UIControlEventValueChanged];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    _invite = [_inviteArray objectAtIndex:indexPath.row];
    PFUser *sendingUser = _invite[@"sender"];
    PFObject *song = _invite[@"song"];
    
    PFFile *songPhoto = [sendingUser objectForKey:@"profileImage"];
    [songPhoto getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error)
     {
         if (!error)
         {
             _imageFile = [UIImage imageWithData:data];
             cell.songImageView.image = _imageFile;
             [cell.songImageView.layer setBorderColor:[[UIColor blackColor]CGColor]];
             [cell.songImageView.layer setBorderWidth:1.3];
             [cell.songImageView.layer setCornerRadius:5.0f];
             [cell.songImageView.layer setMasksToBounds:YES];
         }
         else
         {
             NSLog(@"Something Went Wrong %@",error.localizedDescription);
         }
     }];

    
    [cell.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [cell.layer setBorderWidth:1.3];
    [cell.layer setCornerRadius:0.0f];
    [cell.layer setMasksToBounds:YES];
    cell.backgroundColor = [kColorConstants darkBlueWithAlpha:1.0];
    cell.artistLabel.textColor = [UIColor whiteColor];
    cell.artistLabel.text = sendingUser[@"username"];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _inviteArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_invite[@"accepted"] == FALSE)
    {
        _invite = _inviteArray[indexPath.row];
        PFObject *song = _invite[@"song"];
        [self performSegueWithIdentifier:@"toCollabMediaSegue" sender:song];
    }
    else
    {
        _invite = _inviteArray[indexPath.row];
        PFObject *song = _invite[@"song"];
        [self performSegueWithIdentifier:@"directToChatSegue" sender:song];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (_invite[@"accepted"] == false)
    {
        PFObject *song = (PFObject *)sender;
        CollabMediaViewController *vc = [segue destinationViewController];
        vc.song = song;
        vc.invite = _invite;
    }
    else
    {
        PFObject *song = (PFObject *)sender;
        ChatViewController *vc = [segue destinationViewController];
        vc.invite = _invite;
    }
}


@end
