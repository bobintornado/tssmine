//
//  BuzzCell.h
//  mySMU
//
//  Created by Bob Cao on 22/2/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <UIKit/UIKit.h>

//declare protocol
@protocol BuzzViewCellDelegate;

@interface BuzzCell : UITableViewCell

@property (strong, nonatomic) IBOutlet PFImageView *buzzImg;
@property (strong, nonatomic) IBOutlet UILabel *thumbsups;
@property (strong, nonatomic) IBOutlet UILabel *buzzTitle;
@property (strong, nonatomic) IBOutlet UIButton *thumbUpButton;
@property (strong, nonatomic) PFObject *buzzObject;

/*! @name Delegate */
@property (nonatomic,weak) id <BuzzViewCellDelegate> delegate;

/*!
 Enable the like button to start receiving actions.
 @param enable a BOOL indicating if the like button should be enabled.
 */
- (void)shouldEnableThumbUpButton:(BOOL)enable;
- (void)setThumbUpStatus:(BOOL)status;

@end

@protocol BuzzViewCellDelegate <NSObject>
@optional
/*!
 Sent to the delegate when the like photo button is tapped
 @param photo the PFObject for the photo that is being liked or disliked
 */
- (void)buzzViewCell:(BuzzCell *)buzzViewCell didTapLikeButton:(UIButton *)button Buzz:(PFObject *)buzz;

@end

