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

@property (strong, nonatomic) NSArray *invitedYesArray;
@property (strong, nonatomic) NSArray *invitedNoArray;
@property (strong, nonatomic) NSArray *sentYesArray;
@property (strong, nonatomic) NSArray *sentNoArray;

@property (strong, nonatomic) NSMutableArray *collectiveInviteArray;


/*
***This controller is NOT working***
 
--------------------------------------------------------------------------------------------------------------------
 *PROBLEM: Even when values are false or "Not Accepted" it still fires to the chat segue.
--------------------------------------------------------------------------------------------------------------------

Possible Solution to problem 1 A.

Assumption is that the query is messed up.try fixing query by querying for 2
different values, invites that are accepted and ones that are not, rather than combining queries.
On the frontend, merge those queries into a single array. Have two different MessageTableViewCells
and designate each of them to display the ones that are accepted and the ones that arent.
 
 THIS ANSWER IS WRONG! ^

Possible solution to problem 1 B.

Add a segmented control on the UI, have that dictate which cells to display and which query
to pull when clicked. Similar to the one you had in Project Relay.
*/

@end

@implementation CollabRequestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self inviteQuery];
    [self setNavbar];
    [self checkIfInviteWaAccepted];
    [self useRefreshControl];
    [_tableView reloadData];
}

- (void)setNavbar
{
    [BackendFunctions setupNavbarOnNavbar:self.navigationController onNavigationItem:self.navigationItem];
}

- (void)checkIfInviteWaAccepted
{
    NSError *error = [[NSError alloc]init];
    
    for (_invite in _inviteArray)
    {
        [BackendFunctions checkIfUserIsInvited:_invite withError:error WithReturnObject:^(PFObject *object, NSError *error)
        {
            if (!error && YES)
            {
                _invite = object;
            }
            else
            {
                NSLog(@"error %@", error.localizedDescription);
            }
        }];
    }
}

- (void)inviteQuery
{
    [BackendFunctions inviteQuery:^(NSArray *array, NSError *error)
    {
        if (!error)
        {
            _inviteArray = array;
            [self.tableView reloadData];
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
//    [_tableView reloadData];
    PFUser *invitedUser = _invite[@"receiver"];
    PFUser *sendingUser = _invite[@"sender"];
    [invitedUser fetchIfNeeded];
    [sendingUser fetchIfNeeded];
//    PFObject *song = _invite[@"song"];
    
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
    
    if (_invite[@"accepted"] == [NSNumber numberWithBool:NO])
    {
        cell.backgroundColor = [UIColor redColor];
    }
    else
    {
        cell.backgroundColor = [kColorConstants darkBlueWithAlpha:1.0];
    }
//    cell.backgroundColor = [kColorConstants darkBlueWithAlpha:1.0];
    cell.artistLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
#warning PROBLEM 1
    if (_invite[@"accepted"] == [NSNumber numberWithBool:NO])
    {
        _invite = _inviteArray[indexPath.row];
        PFObject *song = _invite[@"song"];
        [self performSegueWithIdentifier:@"toCollabMediaSegue" sender:song];
    }
    else if (_invite[@"accepted"] == [NSNumber numberWithBool:YES])
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
    PFObject *song = (PFObject *)sender;
    
    //if (_invite[@"accepted"] == [NSNumber numberWithBool:NO])
    if ([segue.identifier isEqualToString:@"toCollabMediaSegue"])
    {
        CollabMediaViewController *vc = [segue destinationViewController];
        vc.song = song;
        vc.invite = _invite;
    }
    //else if (_invite[@"accepted"] == [NSNumber numberWithBool:YES])
    else if ([segue.identifier isEqualToString:@"directToChatSegue"])
    {
        ChatViewController *vc = [segue destinationViewController];
        vc.invite = _invite;
    }
}


@end
