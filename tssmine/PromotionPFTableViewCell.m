//
//  PromotionPFTableViewCell.m
//  TheSMUShop
//
//  Created by Bob Cao on 20/2/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "PromotionPFTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation PromotionPFTableViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib{
//    self.containerView.layer.cornerRadius = 5.0f;
    self.containerView.clipsToBounds = YES;
    
    UIView *v = self.containerView;
    // border radius
    [v.layer setCornerRadius:5.0f];
    
    // border
    [v.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [v.layer setBorderWidth:1.5f];
    
    // drop shadow
    [v.layer setShadowColor:[UIColor blackColor].CGColor];
    [v.layer setShadowOpacity:0.8];
    [v.layer setShadowRadius:3.0];
    [v.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
