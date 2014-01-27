//
//  QuizCenter.m
//  tssmine
//
//  Created by Bob Cao on 27/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "QuizCenter.h"

@implementation QuizCenter

static QuizCenter *sharedCenter = nil;

+ (QuizCenter *)sharedCenter {
    
    static QuizCenter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[QuizCenter alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        _result = @"AAAA";
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
