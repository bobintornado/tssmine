//
//  StyleCenter.h
//  TheSMUShop
//
//  Created by Bob Cao on 28/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSSProduct.h"

@interface StyleCenter : NSObject

@property (nonatomic, retain) TSSProduct *upper;
@property (nonatomic, retain) TSSProduct *bottom;
@property (nonatomic, retain) TSSProduct *slipper;

+ (StyleCenter *)sharedCenter;

@end
