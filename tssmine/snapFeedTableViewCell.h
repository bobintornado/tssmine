//
//  snapFeedTableViewCell.h
//  tssmine
//
//  Created by Bob Cao on 7/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <Parse/Parse.h>

@protocol snapFeedTableViewCellDelegate;

@interface snapFeedTableViewCell : PFTableViewCell

//The PFimageView used to display the photo
@property (strong, nonatomic) IBOutlet PFImageView *snapPhoto;

/// The snapPhoto associated with this view
@property (nonatomic,strong) PFObject *snapPhotoObject;
@property (strong, nonatomic) IBOutlet UIButton *snapLikeButton;
@property (strong, nonatomic) IBOutlet UIButton *snapCommentButton;

//Display statistics about snap
@property (strong, nonatomic) IBOutlet UILabel *snapStatsLabel;

/*! @name Delegate */
@property (nonatomic,weak) id <snapFeedTableViewCellDelegate> delegate;

/*!
 Enable the like button to start receiving actions.
 @param enable a BOOL indicating if the like button should be enabled.
 */
- (void)shouldEnableLikeButton:(BOOL)enable;

/*!
 Configures the Like Button to match the given like status.
 @param liked a BOOL indicating if the associated photo is liked by the user
 */
- (void)setLikeStatus:(BOOL)liked;

@end

@protocol snapFeedTableViewCellDelegate <NSObject>
@optional
/*!
 Sent to the delegate when the like photo button is tapped
 @param photo the PFObject for the photo that is being liked or disliked
 */
- (void)snapFeedTableViewCell:(snapFeedTableViewCell *)snapFeedTableViewCell didTapLikeButton:(UIButton *)button Snap:(PFObject *)snap;
@end