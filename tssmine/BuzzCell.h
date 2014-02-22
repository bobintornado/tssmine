//
//  BuzzCell.h
//  mySMU
//
//  Created by Bob Cao on 22/2/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuzzCell : UITableViewCell

@property (strong, nonatomic) IBOutlet PFImageView *buzzImg;
@property (strong, nonatomic) IBOutlet UILabel *thumbsups;
@property (strong, nonatomic) IBOutlet UILabel *buzzTitle;
@property (strong, nonatomic) IBOutlet UIButton *thumbUpButton;

@end
