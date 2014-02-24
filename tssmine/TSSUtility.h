//
//  TSSUtility.h
//  tssmine
//
//  Created by Bob Cao on 9/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSSUtility : NSObject

+ (void)thumbUpBuzzInBackground:(id)buzz block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

+ (void)unThumbUpBuzzInBackground:(id)snap block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

@end
