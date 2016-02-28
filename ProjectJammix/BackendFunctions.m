//
//  BackendFunctions.m
//  ProjectJammix
//
//  Created by Irwin Gonzales on 2/23/16.
//  Copyright © 2016 Irwin Gonzales. All rights reserved.
//

#import "BackendFunctions.h"
#import <Parse/Parse.h>

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

+ (void)chatQueryWithSpotId:(NSString *)spotId
                    inArray:(ArrayReturnBlock)returnArray
{
    PFObject *chatObject = [PFObject objectWithClassName:@"ChatWidget"];
    
    PFQuery *chatWidgetQuery = [PFQuery queryWithClassName:@"ChatWidget"];
    [chatWidgetQuery whereKey:chatObject[@"objectId"] equalTo:spotId];
    [chatWidgetQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
     {
         if (!error)
         {
             NSLog(@"NO ERROR");
         }
         else
         {
             NSLog(@"%@",error.localizedDescription);
         }
         returnArray(objects, error);
     }];
}

+ (void)saveChatMessageWithText:(NSString *)message
                       withUser:(PFUser *)user
                      andSpotId: (PFObject *)spot
{
    user = [PFUser user];
    spot = [PFObject objectWithClassName:@"Cypher"];
    PFObject *chatMessage = [PFObject objectWithClassName:@"ChatWidget"];
    
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
     {
         
         if (!error && succeeded)
         {
             chatMessage[@"sender"] = user.objectId;
             chatMessage[@"cypher"] = spot.objectId;
             chatMessage[@"message"] = message;
         }
         else
         {
             NSLog(@"YOU SHALL NOT PASS %@",error.localizedDescription);
         }
         
     }];
}

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

+ (void)inviteQuery:(ArrayReturnBlock)returnArray
{
    PFQuery *query1 = [PFQuery queryWithClassName:@"Invite"];
//    [query1 selectKeys:@[@"receiver",@"sender",@"song",@"accepted"]];
    [query1 whereKey:@"receiver" equalTo:[PFUser currentUser]];
    
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"Invite"];
    [query2 whereKey:@"sender" equalTo:[PFUser currentUser]];
    
    PFQuery *mainQuery = [PFQuery orQueryWithSubqueries:@[query1, query2]];
    [mainQuery selectKeys:@[@"receiver",@"sender",@"song",@"accepted"]];
    [mainQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
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

+ (void)messageQueryWithInviteId:(PFObject *)invite
                 onReturnArray:(ArrayReturnBlock)returnArray
{
    PFQuery *mainQuery = [PFQuery queryWithClassName:@"Message"];
    [mainQuery whereKey:@"invite" equalTo:invite];
    [mainQuery selectKeys:@[@"senderName",@"sender"]];
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

@end
