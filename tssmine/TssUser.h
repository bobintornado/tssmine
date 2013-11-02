//
//  TssUser.h
//  tssmine
//
//  Created by Bob Cao on 3/11/13.
//  Copyright (c) 2013 Bob Cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TssUser : NSObject

@property (strong,nonatomic) NSString *email;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSNumber *point;
@property (strong,nonatomic) NSData *profile;

@end
