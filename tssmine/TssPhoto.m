//
//  TssPhoto.m
//  tssmine
//
//  Created by Bob Cao on 3/11/13.
//  Copyright (c) 2013 Bob Cao. All rights reserved.
//

#import "TssPhoto.h"

@implementation TssPhoto

- (id)initWithDescription:(NSString *)description Owner:(NSNumber *)owner Image:(NSData *)image
               Created_at:(NSString *)created_at{
    self = [super init];
    if (self) {
        _description = description;
        _owner = owner;
        _image = image;
        _created_at = created_at;
    }
    return self;
}
@end
