//
//  ProductViewController.h
//  mySMU
//
//  Created by Bob Cao on 11/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSSProduct.h"
#import "OptionTableViewController.h"

@interface ProductViewController : UIViewController <OptionDelegate>

@property (strong, nonatomic) TSSProduct *product;

@end
