//
//  TSSProductCell.h
//  mySMU
//
//  Created by Bob Cao on 9/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSSProductCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *pThumb;
@property (strong, nonatomic) IBOutlet UILabel *pTitle;
@property (strong, nonatomic) IBOutlet UILabel *pPrice;

@end
