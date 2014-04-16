//
//  ProductInCart.h
//  mySMUShop
//
//  Created by Bob Cao on 16/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductInCart : NSObject

@property NSString *key;
@property NSString *name;
@property NSURL *thumb;
@property NSString *option_name;
@property NSString *option_value;
@property NSString *option_name2;
@property NSString *option_value2;
@property NSString *quantity;
@property NSURL *remove;

@end
