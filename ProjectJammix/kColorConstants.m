//
//  kColorConstants.m
//  ProjectJammix
//
//  Created by Irwin Gonzales on 2/27/16.
//  Copyright © 2016 Irwin Gonzales. All rights reserved.
//

#import "kColorConstants.h"

@implementation kColorConstants


+(UIColor *)darkBlueWithAlpha:(float)alpha
{
    return [UIColor colorWithRed:115.0/255.0 green:135.0/255.0 blue:156.0/255.0 alpha:alpha];
}

+(UIColor *)darkerBlueWithAlpha:(float)alpha
{
    return [UIColor colorWithRed:23.0/255.0 green:45.0/255.0 blue:68.0/255.0 alpha:alpha];
}

+(UIColor *)greenWithAlpha:(float)alpha
{
    return [UIColor colorWithRed:92.0/255.0 green:184.0/255.0 blue:92.0/255.0 alpha:alpha];
}

@end
