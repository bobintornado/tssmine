//
//  QuizCenter.h
//  tssmine
//
//  Created by Bob Cao on 27/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuizCenter : NSObject

@property (nonatomic, retain) NSString *result;

+ (QuizCenter *)sharedCenter;

@end
