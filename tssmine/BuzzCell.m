//
//  BuzzCell.m
//  mySMU
//
//  Created by Bob Cao on 22/2/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "BuzzCell.h"

@implementation BuzzCell

- (void)shouldEnableThumbUpButton:(BOOL)enable{
    if(enable){
        [self.thumbUpButton addTarget:self action:@selector(didTapLikeButton:) forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"like add back");
    } else {
        [self.thumbUpButton removeTarget:self action:@selector(didTapLikeButton:) forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"like remove");
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapLikeButton:(id)sender {
    
    if (![PFUser currentUser]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@""
                                                     message:@"You Need to Login/Sign Up in order to thump up a buzz, tab Profile for more information"
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"OK", nil];
        [av show];
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(buzzViewCell:didTapLikeButton:Buzz:)]){
            [_delegate buzzViewCell:self didTapLikeButton:sender Buzz:self.buzzObject];
        }
    }
}

@end
