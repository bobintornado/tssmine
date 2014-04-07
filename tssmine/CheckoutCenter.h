//
//  CheckoutCenter.h
//  mySMUShop
//
//  Created by Bob Cao on 17/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckoutCenter : NSObject

@property (nonatomic, retain) NSString *total;

+ (CheckoutCenter *)sharedCenter;

@end
