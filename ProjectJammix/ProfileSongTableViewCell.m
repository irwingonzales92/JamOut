//
//  ProfileSongTableViewCell.m
//  ProjectJammix
//
//  Created by Irwin Gonzales on 2/28/16.
//  Copyright © 2016 Irwin Gonzales. All rights reserved.
//

#import "ProfileSongTableViewCell.h"

@implementation ProfileSongTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (void)setStyleingWithCell:(ProfileSongTableViewCell *)cell
{
    [cell.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [cell.layer setBorderWidth:1.9];
    [cell.layer setCornerRadius:0.0f];
    [cell.layer setMasksToBounds:YES];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
