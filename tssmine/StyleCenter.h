//
//  StyleCenter.h
//  TheSMUShop
//
//  Created by Bob Cao on 28/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StyleCenter : NSObject

@property (nonatomic, retain) PFObject *upper;
@property (nonatomic, retain) PFObject *under;
@property (nonatomic, retain) PFObject *bottom;

+ (StyleCenter *)sharedCenter;

@end
