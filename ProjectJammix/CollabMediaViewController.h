//
//  CollabMediaViewController.h
//  ProjectJammix
//
//  Created by Irwin Gonzales on 2/27/16.
//  Copyright © 2016 Irwin Gonzales. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CollabMediaViewController : UIViewController

@property (strong, nonatomic) PFObject *song;
@property (strong, nonatomic) PFObject *invite;

@end
