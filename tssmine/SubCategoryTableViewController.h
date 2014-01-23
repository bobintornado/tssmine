//
//  SubCategoryTableViewController.h
//  tssmine
//
//  Created by Bob Cao on 23/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <Parse/Parse.h>

@interface SubCategoryTableViewController : PFQueryTableViewController

@property (strong,nonatomic) PFObject *parentCategory;

@end
