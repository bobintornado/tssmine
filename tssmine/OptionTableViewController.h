//
//  OptionTableViewController.h
//  mySMUShop
//
//  Created by Bob Cao on 14/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSSOption.h"
#import "TSSOptionValue.h"

@protocol OptionDelegate;

@interface OptionTableViewController : UITableViewController

@property (strong, nonatomic) TSSOption *option;
@property (strong) TSSOptionValue *chosenOptionValue;
@property (nonatomic, assign) id<OptionDelegate> delegate;
@property (strong, nonatomic) NSNumber *target;

@end

@protocol OptionDelegate

- (void)setChosenOption:(OptionTableViewController*)OptionTableViewController;

@end