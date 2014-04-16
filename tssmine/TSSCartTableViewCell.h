//
//  TSSCartTableViewCell.h
//  mySMUShop
//
//  Created by Bob Cao on 16/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSSCartTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UILabel *optionValue;
@property (strong, nonatomic) IBOutlet UILabel *optionValue2;
@property (strong, nonatomic) IBOutlet UILabel *quantity;

@end
