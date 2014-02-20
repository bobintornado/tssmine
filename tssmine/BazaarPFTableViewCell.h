//
//  BazaarPFTableViewCell.h
//  mySMU
//
//  Created by Bob Cao on 21/2/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <Parse/Parse.h>

@interface BazaarPFTableViewCell : PFTableViewCell

@property (strong, nonatomic) IBOutlet PFImageView *itemImg;
@property (strong, nonatomic) IBOutlet UILabel *itemTitle;
@property (strong, nonatomic) IBOutlet UITextView *itemDes;
@property (strong, nonatomic) IBOutlet UILabel *itemPrice;
@property (strong, nonatomic) IBOutlet UILabel *itemContact;

@end
