//
//  StyleCenter.m
//  TheSMUShop
//
//  Created by Bob Cao on 28/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "StyleCenter.h"

@implementation StyleCenter

static StyleCenter *sharedCenter = nil;

+ (StyleCenter *)sharedCenter {
    
    static StyleCenter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[StyleCenter alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        self.upper = [PFObject objectWithClassName:@"TSSProduct"];
        self.under = [PFObject objectWithClassName:@"TSSProduct"];
        self.bottom = [PFObject objectWithClassName:@"TSSProduct"];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}


@end
