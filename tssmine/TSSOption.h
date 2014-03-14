//
//  TSSOption.h
//  mySMU
//
//  Created by Bob Cao on 11/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSSOption : NSObject

@property (strong) NSString *product_option_id;
@property (strong) NSString *optionId;
@property (strong) NSString *name;
@property (strong) NSString *type;
@property (strong) NSMutableArray *optionValues;

@end
