//
//  SongListViewController.m
//  ProjectJammix
//
//  Created by Irwin Gonzales on 2/26/16.
//  Copyright © 2016 Irwin Gonzales. All rights reserved.
//

#import "SongListViewController.h"
#import <Parse/Parse.h>
#import "kColorConstants.h"

@interface SongListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *songListArray;
@property (strong, nonatomic) NSArray *userArray;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) PFObject *localSongs;
//@property (strong, nonatomic) PFObject *song;
@property (strong, nonatomic) UIAlertController *alert;

@end

@implementation SongListViewController

- (void)dealloc
{
    //Degister for the notification.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavbar];
    [self setTableViewColor];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Song"];
    
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    {
        if (!error)
        {
            _songListArray = objects;
            [_tableView reloadData];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successfullyPostedToParse) name:@"savedToParseSuccess" object:nil];
    
    self.view.backgroundColor = [kColorConstants darkerBlueWithAlpha:1.0];
}

- (void)setTableViewColor
{
    [_tableView.layer setBorderColor:[[kColorConstants darkBlueWithAlpha:1.0] CGColor]];
    [_tableView.layer setBorderWidth:1.9];
    [_tableView.layer setCornerRadius:0.0f];
    [_tableView.layer setMasksToBounds:YES];
    
}

- (void)setNavbar
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor blackColor],
                                                                       NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:20.0f]                                                                      }];
    [self.navigationController.navigationBar setBackgroundColor:[kColorConstants darkerBlueWithAlpha:1.0]];
    [self.navigationItem setTitle: @"Jammout"];
}


- (void)successfullyPostedToParse
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _songListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    _localSongs = [_songListArray objectAtIndex:indexPath.row];
    cell.textLabel.text = _localSongs[@"title"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _alert = [UIAlertController alertControllerWithTitle:@"Are You Sure You Want To Send This Song?"
                                                 message:nil
                                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *okay = [UIAlertAction actionWithTitle:@"Send" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                           {
                               [self performSelector:@selector(sendInvite) withObject:NULL afterDelay:0];
                           }];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    
    [_alert addAction:cancel];
    [_alert addAction:okay];
    [self presentViewController:_alert animated:YES completion:nil];
}

-(void)sendInvite;
{
    PFUser *cUser = [PFUser currentUser];
    PFObject *invite = [PFObject objectWithClassName:@"Invite"];
    [invite setObject:cUser forKey:@"sender"];
    [invite setObject:_song[@"user"] forKey:@"receiver"];
    [invite setObject:_localSongs forKey:@"song"];
    [invite setValue:[NSNumber numberWithBool:false] forKey:@"accepted"];
    [invite saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
    {
        if (!error && succeeded)
        {
            NSLog(@"Message Sent");
            [invite save];
            //Post a notification "savedToParseSuccess"
            [[NSNotificationCenter defaultCenter] postNotificationName:@"savedToParseSuccess" object:nil];
        }
    }];
    
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}


@end
