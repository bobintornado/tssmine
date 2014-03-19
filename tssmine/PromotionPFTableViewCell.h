//
//  PromotionPFTableViewCell.h
//  TheSMUShop
//
//  Created by Bob Cao on 20/2/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <Parse/Parse.h>

@interface PromotionPFTableViewCell : PFTableViewCell

@property (strong, nonatomic) IBOutlet PFImageView *promotionImage;
@property (strong, nonatomic) IBOutlet UILabel *expiryDate;
@property (strong, nonatomic) IBOutlet UIView *containerView;

@end
