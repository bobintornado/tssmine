//
//  TssPhotoCommunicator.h
//  tssmine
//
//  Created by Bob Cao on 4/11/13.
//  Copyright (c) 2013 Bob Cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TssPhotoCommunicatorDelegate;

@interface TssPhotoCommunicator : NSObject

@property (weak,nonatomic) id <TssPhotoCommunicatorDelegate> delegate;

-(void)retrieveAll;

@end
