//
//  TssPhotoBuilder.h
//  tssmine
//
//  Created by Bob Cao on 4/11/13.
//  Copyright (c) 2013 Bob Cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TssPhotoBuilder : NSObject

+ (NSArray *)tssPhotosFromJSON:(NSData *)objectNotation error:(NSError **)error;

@end
