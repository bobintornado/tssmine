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
        self.firstName = @"";
        self.lastName = @"";
        self.email = @"";
        self.telephone = @"";
        self.company = @"";
        self.address = @"";
        self.salutation = @"Current Student";
        self.customer_group_id = @"1";
        self.postcode = @"";
    }
    return self;
}


@end
