//
//  TSSProduct.h
//  mySMU
//
//  Created by Bob Cao on 9/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSSOption.h"

@interface TSSProduct : NSObject

@property NSString *productID;
@property NSString *name;
@property NSURL  *thumbURL;
@property NSString *price;

@property NSURL *image;
@property NSMutableArray *images;

//for now there is only one option
@property TSSOption *option;

@end
