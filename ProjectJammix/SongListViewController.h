//
//  SongListViewController.h
//  ProjectJammix
//
//  Created by Irwin Gonzales on 2/26/16.
//  Copyright © 2016 Irwin Gonzales. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SongListViewController : UIViewController

@property (strong, nonatomic) PFObject *song;

@end
