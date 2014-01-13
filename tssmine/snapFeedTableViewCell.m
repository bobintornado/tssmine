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

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)shouldEnableLikeButton:(BOOL)enable{
    if(enable){
        [self.snapLikeButton addTarget:self action:@selector(didTapLikeButton:) forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"like add back");
    } else {
        [self.snapLikeButton removeTarget:self action:@selector(didTapLikeButton:) forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"like remove");
    }
}

- (void)setLikeStatus:(BOOL)liked {
    [self.snapLikeButton setSelected:liked];
    if (liked) {
        [self.snapLikeButton setTitleEdgeInsets:UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0f)];
        [[self.snapLikeButton titleLabel] setShadowOffset:CGSizeMake(0.0f, -1.0f)];
        [self.snapLikeButton setTitle:@"liked" forState:UIControlStateNormal];
    } else {
        [self.snapLikeButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        [[self.snapLikeButton titleLabel] setShadowOffset:CGSizeMake(0.0f, 1.0f)];
        [self.snapLikeButton setTitle:@"like" forState:UIControlStateNormal];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation. */
//- (void)drawRect:(CGRect)rect
//{
//    
//}

- (IBAction)didTapLikeButton:(id)sender {
    NSLog(@"touch Detect");
    if (delegate && [delegate respondsToSelector:@selector(snapFeedTableViewCell:didTapLikeButton:Snap:)]){
        [delegate snapFeedTableViewCell:self didTapLikeButton:sender Snap:self.snapPhotoObject];
        NSLog(@"likeTapExecute");
    }
}


@end