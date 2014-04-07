//
//  PaymentCenter.h
//  mySMUShop
//
//  Created by Bob Cao on 24/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentCenter : NSObject

@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *telephone;
@property (nonatomic, retain) NSString *salutation;
@property (nonatomic, retain) NSString *customer_group_id;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *postcode;
@property (nonatomic, retain) NSString *total;

@property (nonatomic, retain) NSString *shippingcode;
@property (nonatomic, retain) NSString *payment_method;

@property (nonatomic, retain) NSString *fax;
@property (nonatomic, retain) NSString *company;

@property (nonatomic, retain) NSString *custom;

+ (PaymentCenter *)sharedCenter;

@end
