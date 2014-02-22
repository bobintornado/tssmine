//
//  Filter.h
//  mySMU
//
//  Created by Bob Cao on 23/2/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Filter : NSObject

-(id) initWithNameAndFilter:(NSString *) theName filter:(CIFilter *) theFilter;

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) CIFilter *filter;

@end
