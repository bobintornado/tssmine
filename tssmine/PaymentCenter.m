//
//  PaymentCenter.m
//  mySMUShop
//
//  Created by Bob Cao on 24/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "PaymentCenter.h"

@implementation PaymentCenter


+ (PaymentCenter *)sharedCenter {
    
    static PaymentCenter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PaymentCenter alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        self.firstName = @"Your First Name";
        self.lastName = @"Your Last Name";
        self.email = @"For Sending Invoice";
        self.telephone = @"88888888";
        self.salutation = @"Current Student";
    }
    return self;
}


@end
