//
//  snapFeedTableViewCell.h
//  tssmine
//
//  Created by Bob Cao on 7/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <Parse/Parse.h>

@interface snapFeedTableViewCell : PFTableViewCell

//The PFimageView used to display the photo
@property (strong, nonatomic) IBOutlet PFImageView *snapPhoto;

/// The snapPhoto associated with this view
@property (nonatomic,strong) PFObject *snapPhotoObject;

@end
