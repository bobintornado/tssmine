//
//  CheckoutCenter.m
//  mySMUShop
//
//  Created by Bob Cao on 17/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "CheckoutCenter.h"

@implementation CheckoutCenter

+ (CheckoutCenter *)sharedCenter {
    
    static CheckoutCenter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CheckoutCenter alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

@end
