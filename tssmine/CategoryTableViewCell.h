//
//  CategoryTableViewCell.h
//  tssmine
//
//  Created by Bob Cao on 19/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <Parse/Parse.h>

@interface CategoryTableViewCell : PFTableViewCell
@property (strong, nonatomic) IBOutlet PFImageView *categoryImage;
@property (strong, nonatomic) IBOutlet UILabel *CategoryName;

@end
