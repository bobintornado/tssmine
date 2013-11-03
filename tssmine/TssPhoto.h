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
@property (strong,nonatomic) NSNumber *user_id;
@property (strong,nonatomic) NSString *photo;
@property (strong,nonatomic) NSString *created_at;

- (id)initWithDescription:(NSString *)description Owner:(NSNumber *)owner Image:(NSString *)image
               Created_at:(NSString *)created_at;

@end
