//
//  MMTableViewCell.m
//  Morning Mantra
//
//  Created by Christian Hatch on 7/23/14.
//  Copyright (c) 2014 Knot Labs. All rights reserved.
//

#import "MMTableViewCell.h"

@implementation MMTableViewCell

- (void)awakeFromNib
{
//    self.contentView.backgroundColor = [UIColor greenColor];
//    self.mantraLabel.backgroundColor = [UIColor yellowColor]; 
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView layoutIfNeeded];
    self.mantraLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.mantraLabel.frame);
}

@end
