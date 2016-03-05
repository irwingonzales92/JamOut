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
    [cell.songLabel setFont:[UIFont fontWithName:@"Avenir" size:20]];
    cell.songLabel.textColor = [UIColor whiteColor];
    [cell.artistLabel setFont:[UIFont fontWithName:@"Avenir" size:15]];
    cell.artistLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

// Parallax Effect On Custom Cell
- (void)cellOnTableView:(UITableView *)tableView didScrollOnView:(UIView *)view
{
    CGRect rectInSuperview = [tableView convertRect:self.frame toView:view];
    
    float distanceFromCenter = CGRectGetHeight(view.frame)/2 - CGRectGetMinY(rectInSuperview);
    float difference = CGRectGetHeight(self.customImageView.frame) - CGRectGetHeight(self.frame);
    float move = (distanceFromCenter / CGRectGetHeight(view.frame)) * difference;
    
    CGRect imageRect = self.customImageView.frame;
    imageRect.origin.y = -(difference/2)+move;
    self.customImageView.frame = imageRect;
}

@end
