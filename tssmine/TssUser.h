//
//  TssUser.h
//  tssmine
//
//  Created by Bob Cao on 3/11/13.
//  Copyright (c) 2013 Bob Cao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSRails.h"

@interface TssUser: NSRRemoteObject

@property (strong,nonatomic) NSString *email;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *password;
@property (strong,nonatomic) NSNumber *point;
@property (strong,nonatomic) NSString *profile;

@end
