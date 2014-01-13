//
//  SnapDetailViewController.h
//  tssmine
//
//  Created by Bob Cao on 6/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnapDetailViewController : UIViewController


@property (strong, nonatomic) IBOutlet PFImageView *snapPFImageView;
@property (strong, nonatomic) IBOutlet UILabel *detailStatLab;
@property (strong, nonatomic) IBOutlet UIButton *detailCommentButton;
@property (strong, nonatomic) IBOutlet UIButton *detailLikeButton;

@property (strong, nonatomic) PFObject *snapObject;

- (void)setUpDetailViewWithObject:(PFObject *)snapObject;

@end
