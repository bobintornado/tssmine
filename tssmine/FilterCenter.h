//
//  FilterCenter.h
//  mySMUShop
//
//  Created by Bob Cao on 25/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterCenter : NSObject

@property (nonatomic) int buzzFilter;
@property (nonatomic) int bazaarFilter;
@property (nonatomic, strong) PFObject *postCategory;
@property (nonatomic, strong) PFObject *filterCategory;

+ (FilterCenter *)sharedCenter;

@end
