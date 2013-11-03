//
//  TssPhotosManager.h
//  tssmine
//
//  Created by Bob Cao on 4/11/13.
//  Copyright (c) 2013 Bob Cao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TssPhotoManagerDelegate.h"
#import "TssPhotoCommunicatorDelegate.h"

@class TssPhotoCommunicator;

@interface TssPhotosManager : NSObject <TssPhotoCommunicatorDelegate>

@property (strong,nonatomic) TssPhotoCommunicator *communicator;
@property (weak, nonatomic) id <TssPhotoManagerDelegate> delegate;

- (void)fetchTssPhotos;

@end
