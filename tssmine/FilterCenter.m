//
//  FilterCenter.m
//  mySMUShop
//
//  Created by Bob Cao on 25/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "FilterCenter.h"

@implementation FilterCenter

+ (FilterCenter *)sharedCenter {
    
    static FilterCenter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FilterCenter alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        self.buzzFilter = 0;
        self.bazaarFilter = 0;
    }
    return self;
}

@end
