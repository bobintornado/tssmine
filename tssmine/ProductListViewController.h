//
//  ProductListViewController.h
//  mySMU
//
//  Created by Bob Cao on 9/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSSCategories.h"

@interface ProductListViewController : UITableViewController

@property (nonatomic, strong) TSSCategories *category;

@end
