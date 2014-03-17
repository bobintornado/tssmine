//
//  CheckoutCenter.h
//  mySMUShop
//
//  Created by Bob Cao on 17/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckoutCenter : NSObject

@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *itemCount;
@property (nonatomic, retain) NSString *total;
@property (nonatomic, retain) NSString *salutation;
@property (nonatomic, retain) NSString *deliveryMethod;

+ (CheckoutCenter *)sharedCenter;

@end
