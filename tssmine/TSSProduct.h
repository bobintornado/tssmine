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

@property (strong,nonatomic) NSString *productID;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSURL  *thumbURL;
@property (strong,nonatomic) NSString *price;

@property (strong,nonatomic) NSURL *image;
@property (strong,nonatomic) NSMutableArray *images;

//for now there is only one option
@property (strong, nonatomic)TSSOption *option;

@property (strong, nonatomic) NSString *pDescription;


@end
