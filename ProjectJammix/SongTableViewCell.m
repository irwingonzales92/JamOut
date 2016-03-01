//
//  SongTableViewCell.m
//  ProjectJammix
//
//  Created by Irwin Gonzales on 2/27/16.
//  Copyright © 2016 Irwin Gonzales. All rights reserved.
//

#import "SongTableViewCell.h"

@implementation SongTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (void)setStyleingWithCell:(SongTableViewCell *)cell
{
    [cell.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [cell.layer setBorderWidth:1.9];
    [cell.layer setCornerRadius:0.0f];
    [cell.layer setMasksToBounds:YES];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
