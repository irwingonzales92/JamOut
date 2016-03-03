//
//  BackendFunctions.m
//  ProjectJammix
//
//  Created by Irwin Gonzales on 2/23/16.
//  Copyright © 2016 Irwin Gonzales. All rights reserved.
//

#import "BackendFunctions.h"
#import <Parse/Parse.h>
#import <AVFoundation/AVFoundation.h>
#import "kColorConstants.h"
#import "SongTableViewCell.h"

@implementation BackendFunctions

#pragma
#pragma mark - Basic User Functions
+ (void)signupUserWithName:(NSString *)username
              WithPassword:(NSString *)password
           ConfirmPassword:(NSString *)confirmPassword
                  AndEmail:(NSString *)email
              onCompletion:(CompletionWithErrorBlock)onCompletion
{
    if ([PFUser user]) [PFUser logOut];
    PFUser *user = [PFUser new];
    user.username = username;
    user.password = password;
    user.email = email;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
     {
         onCompletion(succeeded,error);
     }];
}

+ (void)loginUserWithUsername:(NSString *)username
                  AndPassword:(NSString *)password
                 onCompletion:(CompletionWithErrorBlock)onCompletion
{
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error)
     {
         if (!error)
         {
             NSLog(@"It Works!");
         }
         else
         {
             NSLog(@"It Broke %@",error.localizedDescription);
         }
         onCompletion(user,error);
     }];
}

+ (void)logOut
{
    [PFUser logOut];
}

+ (BOOL)userIsLoggedIn
{
    PFUser *currentUser = [PFUser currentUser];
    return (currentUser) ? YES : NO;
}

+ (NSMutableArray *)queryUserWithUser
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    {
        [array arrayByAddingObjectsFromArray:objects];
    }];
    
    return array;
}

#pragma
#pragma mark - Basic Chat Query & Save

+ (void)userArrayQuery:(ArrayReturnBlock)returnArray
{
    PFQuery *query = [PFUser query];
    [query selectKeys:@[@"objectId", @"username", @"postedSong", @"profileImage"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         returnArray(objects,error);
     }];
}

+ (void)songArrayQuery:(ArrayReturnBlock)returnArray
{
    PFQuery *query = [PFQuery queryWithClassName:@"Song"];
    [query selectKeys:@[@"audio",@"title",@"artist", @"objectId",@"user", @"genre",@"image"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    {
        if (!error)
        {
            returnArray(objects, error);
        }
        else
        {
            NSLog(@"%@",error);
        }
    }];
}

#pragma
#pragma mark - Invite Queries

+ (void)inviteQuery:(ArrayReturnBlock)returnArray
{
    PFQuery *query1 = [PFQuery queryWithClassName:@"Invite"];
//    [query1 selectKeys:@[@"receiver",@"sender",@"song",@"accepted"]];
    [query1 whereKey:@"receiver" equalTo:[PFUser currentUser]];
    
    
//    PFQuery *query2 = [PFQuery queryWithClassName:@"Invite"];
//    [query2 whereKey:@"sender" equalTo:[PFUser currentUser]];
    
    //PFQuery *mainQuery = [PFQuery orQueryWithSubqueries:@[query1, query2]];
    [query1 selectKeys:@[@"receiver",@"sender",@"song",@"accepted"]];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    {
        if (!error)
        {
            returnArray(objects,error);
        }
        else
        {
            NSLog(@"%@",error);
        }
    }];
}

// Reciever Queries
+ (void)acceptedInviteQuery:(ArrayReturnBlock)returnArray
{
    PFQuery *query = [PFQuery queryWithClassName:@"Invite"];
    [query whereKey:@"receiver" equalTo:[PFUser currentUser]];
    [query whereKey:@"accepted" equalTo:[NSNumber numberWithBool:YES]];
    [query selectKeys:@[@"receiver",@"sender",@"song",@"accepted"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    {
        if (!error)
        {
            returnArray(objects, error);
        }
        else
        {
            NSLog(@"%@",error.localizedDescription);
        }
    }];
}

+ (void)notAcceptedInviteQuery:(ArrayReturnBlock)returnArray
{
    PFQuery *query = [PFQuery queryWithClassName:@"Invite"];
    [query whereKey:@"reciever" equalTo:[PFUser currentUser]];
    [query whereKey:@"accepted" equalTo:[NSNumber numberWithBool:NO]];
    [query selectKeys:@[@"receiver",@"sender",@"song",@"accepted"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    {
        if (!error)
        {
            returnArray(objects, error);
        }
        else
        {
            NSLog(@"Cannot Pull Messages %@",error.localizedDescription);
        }
    }];
}

// Sender Queries
+ (void)inviteSentQuery:(ArrayReturnBlock)returnArray
{
    PFQuery *query = [PFQuery queryWithClassName:@"Invite"];
    [query whereKey:@"sender" equalTo:[PFUser currentUser]];
//    [query whereKey:@"accepted" equalTo:[NSNumber numberWithBool:YES]];
//    [query selectKeys:@[@"receiver",@"sender",@"song",@"accepted"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    {
        if (!error)
        {
            returnArray(objects, error);
        }
        else
        {
            NSLog(@"Cannot Pull Messages %@",error.localizedDescription);
        }
    }];
}

+ (void)notAcceptedSentQuery:(ArrayReturnBlock)returnArray
{
    PFQuery *query = [PFQuery queryWithClassName:@"Invite"];
    [query whereKey:@"sender" equalTo:[PFUser currentUser]];
    [query whereKey:@"accepted" equalTo:[NSNumber numberWithBool:NO]];
    [query selectKeys:@[@"receiver",@"sender",@"song",@"accepted"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
     {
         if (!error)
         {
             returnArray(objects, error);
         }
         else
         {
             NSLog(@"Cannot Pull Messages %@",error.localizedDescription);
         }
     }];
}

+ (void)messageQueryWithInviteId:(PFObject *)invite
                 onReturnArray:(ArrayReturnBlock)returnArray
{
    PFQuery *mainQuery = [PFQuery queryWithClassName:@"Message"];
    [mainQuery whereKey:@"invite" equalTo:invite];
    //[mainQuery selectKeys:@[@"senderName",@"sender"]];
//    [mainQuery selectKeys:@[@"sender",@"receiver"]];
    [mainQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    {
        if (!error)
        {
            returnArray(objects, error);
        }
        else
        {
            NSLog(@"Cannot Pull Messages %@",error.localizedDescription);
        }
    }];
}

+ (void)postedSongQueryWithUser:(PFUser *)user andArrayReturnBlock
                               :(ArrayReturnBlock)returnArray
{
    user = [PFUser new];
    PFRelation *relation = [user relationForKey:@"postedSong"];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    {
        returnArray(objects, error);
    }];
}

+ (void)querySongsFromUser:(PFUser *)user
                 WithArray:(ArrayReturnBlock)returnArray
{
    user = [PFUser currentUser];
//    PFObject *song = [PFObject objectWithClassName:@"Song"];
    PFQuery *query = [PFQuery queryWithClassName:@"Song"];
    [query whereKey:@"user" equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    {
        if (!error)
        {
            returnArray(objects, error);
        }
        else
        {
            NSLog(@"%@",error.localizedDescription);
        }
    }];
}

+ (BOOL)checkIfUserIsInvited:(PFObject *)passedInvite withError:(NSError *)error WithReturnObject:(ObjectReturnBlock)returnObject
{
    if (passedInvite[@"accepted"] == [NSNumber numberWithBool:YES])
    {
        returnObject(passedInvite,error);
        return YES;
    }
    else
    {
        NSLog(@"Does Not Match!");
        return NO;
    }
}

+ (UIAlertController *)showNotification:(NSString *)title
                            withMessage: (NSString *)message
                            andSelector:(SEL)selector
                           onCompletion:(CompletionWithErrorBlock)onCompletion
{
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:title
                                message:message
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
    {
        [alert performSelector:selector withObject:nil afterDelay:0];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action)
    {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];

    [alert addAction:ok];
    [alert addAction:cancel];
    return alert;
}

+ (void)buttonSetupWithButton:(UIButton *)button
{
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.borderColor = [[UIColor whiteColor]CGColor];
    button.layer.cornerRadius=8.0f;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1.0f;
}

+ (void)setupCallToActionButton:(UIButton *)button
{
    button.backgroundColor = [kColorConstants greenWithAlpha:1.0];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.borderColor = [[UIColor whiteColor]CGColor];
    button.layer.cornerRadius=8.0f;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1.0f;
}

+ (void)textfieldSetupWithTextfield:(UITextField *)textfield andPlaceholderText:(NSString *)string
{
    textfield.backgroundColor = [UIColor clearColor];
    textfield.layer.cornerRadius=8.0f;
    textfield.layer.masksToBounds=YES;
    textfield.layer.borderColor=[[UIColor whiteColor]CGColor];
    textfield.layer.borderWidth= 1.0f;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:string attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    textfield.attributedPlaceholder = str;
    textfield.textColor = [UIColor whiteColor];
    textfield.tintColor = [UIColor whiteColor];
}

+ (void)setupTableView:(UITableView *)tableView
{
    [tableView.layer setBorderColor:[[kColorConstants darkBlueWithAlpha:1.0] CGColor]];
    [tableView.layer setBorderWidth:1.9];
    [tableView.layer setCornerRadius:0.0f];
    [tableView.layer setMasksToBounds:YES];
}

+ (void)setupImageView:(UIImageView *)imageView
{
    imageView.layer.cornerRadius = 8.0f;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderColor = [[UIColor blackColor]CGColor];
    imageView.layer.borderWidth = 1.0f;
}

+ (void)setupCustomView:(UIView *)view
{
    view.layer.cornerRadius = 8.0f;
    view.layer.masksToBounds = YES;
    view.layer.borderColor = [[UIColor blackColor]CGColor];
    view.layer.borderWidth = 1.0f;
}

@end
