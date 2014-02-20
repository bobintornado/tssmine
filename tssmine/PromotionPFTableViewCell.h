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
@property (strong, nonatomic) IBOutlet UILabel *promotionTitle;
@property (strong, nonatomic) IBOutlet UILabel *promotionSubtitle;
@property (strong, nonatomic) IBOutlet UILabel *expiryDate;
@property (strong, nonatomic) IBOutlet UILabel *discount_slogan;

@end
