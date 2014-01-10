//
//  snapFeedTableViewCell.m
//  tssmine
//
//  Created by Bob Cao on 7/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "snapFeedTableViewCell.h"
#import "TSSUtility.h"

@implementation snapFeedTableViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation. */
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

- (IBAction)didTapLikeButton:(id)sender {
    [TSSUtility likePhotoInBackground:self.snapPhotoObject block:^(BOOL succeeded, NSError *error) {
        //donothing
    }];
}
@end
