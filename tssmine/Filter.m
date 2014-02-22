//
//  Filter.m
//  mySMU
//
//  Created by Bob Cao on 23/2/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "Filter.h"

@implementation Filter

-(id) initWithNameAndFilter:(NSString *)theName filter:(CIFilter *)theFilter
{
    self = [super init];
    self.name = theName;
    self.filter = theFilter;
    return self;
}

@end
