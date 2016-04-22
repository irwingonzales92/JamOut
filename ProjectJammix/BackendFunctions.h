//
//  BackendFunctions.h
//  ProjectJammix
//
//  Created by Irwin Gonzales on 2/23/16.
//  Copyright © 2016 Irwin Gonzales. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


@interface BackendFunctions : NSObject

/////////////////////////////
// block definitions
/////////////////////////////
typedef void (^SuccessCompletionBlock)(BOOL success);
typedef void (^CompletionWithErrorBlock)(BOOL success, NSError *error);
typedef void (^CompletionWithDictionaryBlock)(NSDictionary *dictionary, NSError *error);
typedef void (^CompletionWithArrayBlock)(NSArray *array, NSError *error);
typedef void (^ArrayReturnBlock)(NSArray *array, NSError *error);
typedef void (^ObjectReturnBlock)(PFObject *object, NSError *error);

////////////////////////////////////////////////
////////////////////////////////////////////////
////////
////////           Basic User Activities
////////
////////////////////////////////////////////////
////////////////////////////////////////////////

#pragma
#pragma mark - Basic User Functions
+ (void)signupUserWithName:(NSString *)username
              WithPassword:(NSString *)password
           ConfirmPassword:(NSString *)confirmPassword
                  AndEmail:(NSString *)email
              onCompletion:(CompletionWithErrorBlock)onCompletion;

+ (void)loginUserWithUsername:(NSString *)username
                  AndPassword:(NSString *)password
                 onCompletion:(CompletionWithErrorBlock)onCompletion;

+ (void)logOut;

+ (BOOL)userIsLoggedIn;

////////////////////////////////////////////////
////////////////////////////////////////////////
////////
////////           Object Queries
////////
////////////////////////////////////////////////
////////////////////////////////////////////////

#pragma
#pragma mark - Basic Chat Query/Save
+ (void)userArrayQuery:(ArrayReturnBlock)returnArray;

+ (void)songArrayQuery:(ArrayReturnBlock)returnArray;

+ (void)inviteQuery:(ArrayReturnBlock)returnArray;

+ (void)acceptedInviteQuery:(ArrayReturnBlock)returnArray;

+ (void)notAcceptedInviteQuery:(ArrayReturnBlock)returnArray;

+ (void)inviteSentQuery:(ArrayReturnBlock)returnArray;

+ (void)notAcceptedSentQuery:(ArrayReturnBlock)returnArray;

+ (void)messageQueryWithInviteId:(PFObject *)invite
                   onReturnArray:(ArrayReturnBlock)returnArray;

+ (void)postedSongQueryWithUser:(PFUser *)user andArrayReturnBlock
                               :(ArrayReturnBlock)returnArray;

+ (void)querySongsFromUser:(PFUser *)user
                 WithArray:(ArrayReturnBlock)returnArray;

////////////////////////////////////////////////
////////////////////////////////////////////////
////////
////////           Invite Flags
////////
////////////////////////////////////////////////
////////////////////////////////////////////////

+ (BOOL)checkIfUserIsInvited:(PFObject *)passedInvite
                   withError:(NSError *)error
            WithReturnObject:(ObjectReturnBlock)returnObject;

+ (BOOL)checkIfUserIsNotInvited:(PFObject *)passedInvite
                      withError:(NSError *)error
               WithRetrunObject:(ObjectReturnBlock)returnObject;

////////////////////////////////////////////////
////////////////////////////////////////////////
////////
////////           Alert Controllers
////////
////////////////////////////////////////////////
////////////////////////////////////////////////

+ (UIAlertController *)showNotification:(NSString *)title
                            withMessage: (NSString *)message
                            andSelector:(SEL)selector
                           onCompletion:(CompletionWithErrorBlock)onCompletion;

////////////////////////////////////////////////
////////////////////////////////////////////////
////////
////////           Object Styling
////////
////////////////////////////////////////////////
////////////////////////////////////////////////

#pragma
#pragma mark - Object Styling

+ (void)buttonSetupWithButton:(UIButton *)button;

+ (void)textfieldSetupWithTextfield:(UITextField *)textfield andPlaceholderText:(NSString *)string;

+ (void)setupTableView:(UITableView *)tableView;

+ (void)setupCallToActionButton:(UIButton *)button;

+ (void)setupImageView:(UIImageView *)imageView;

+ (void)setupCustomView:(UIView *)view;

+ (void)setupNavbarOnNavbar:(UINavigationController *)navigationController
           onNavigationItem:(UINavigationItem *)navigationItem;


@end
