//
//  TssPhoto.h
//  tssmine
//
//  Created by Bob Cao on 3/11/13.
//  Copyright (c) 2013 Bob Cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TssPhoto : NSObject

@property (strong,nonatomic) NSString *description;
@property (strong,nonatomic) NSNumber *owner;
@property (strong,nonatomic) NSData *image;
@property (strong,nonatomic) NSString *created_at;

- (id)initWithDescription:(NSString *)description Owner:(NSString *)owner Image:(NSData *)image
               Created_at:(NSString *)created_at;

@end
