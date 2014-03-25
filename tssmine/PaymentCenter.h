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

+ (PaymentCenter *)sharedCenter;

@end
