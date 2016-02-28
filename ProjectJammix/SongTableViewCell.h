//
//  SongTableViewCell.h
//  ProjectJammix
//
//  Created by Irwin Gonzales on 2/27/16.
//  Copyright © 2016 Irwin Gonzales. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *artistLabel;

@property (strong, nonatomic) IBOutlet UIImageView *customImageView;
@property (strong, nonatomic) IBOutlet UILabel *songLabel;
@end
