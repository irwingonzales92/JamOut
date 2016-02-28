//
//  MessageTableViewCell.h
//  ProjectJammix
//
//  Created by Irwin Gonzales on 2/28/16.
//  Copyright © 2016 Irwin Gonzales. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *artistLabel;

@property (strong, nonatomic) IBOutlet UIImageView *songImageView;
@end
