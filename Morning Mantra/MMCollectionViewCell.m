//
//  MMCollectionViewCell.m
//  Morning Mantra
//
//  Created by Christian Hatch on 8/8/14.
//  Copyright (c) 2014 Knot Labs. All rights reserved.
//

#import "MMCollectionViewCell.h"

@interface MMCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *topRightButton;
@end

@implementation MMCollectionViewCell

static CGSize _extraMargins = {0,0};

- (CGSize)intrinsicContentSize
{
    CGSize size = [self.label intrinsicContentSize];
    
    if (CGSizeEqualToSize(_extraMargins, CGSizeZero))
    {
        // quick and dirty: get extra margins from constraints
        for (NSLayoutConstraint *constraint in self.constraints)
        {
            if (constraint.firstAttribute == NSLayoutAttributeBottom || constraint.firstAttribute == NSLayoutAttributeTop)
            {
                // vertical spacer
                _extraMargins.height += [constraint constant];
            }
            else if (constraint.firstAttribute == NSLayoutAttributeLeading || constraint.firstAttribute == NSLayoutAttributeTrailing)
            {
                // horizontal spacer
                _extraMargins.width += [constraint constant];
            }
        }
    }
    
    // add to intrinsic content size of label
    size.width += _extraMargins.width;
    size.height += _extraMargins.height;
    
    return size;
}


@end
