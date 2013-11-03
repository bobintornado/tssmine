//
//  TssPhotosManager.m
//  tssmine
//
//  Created by Bob Cao on 4/11/13.
//  Copyright (c) 2013 Bob Cao. All rights reserved.
//

#import "TssPhotosManager.h"
#import "TssPhotoBuilder.h"
#import "TssPhotoCommunicator.h"

@implementation TssPhotosManager

- (void)fetchTssPhotos{
    
    [self.communicator tryFetchingAll];
}

#pragma mark - TssPhotoCommunicatorDelegate

- (void) receivedTssPhotosJSON:(NSData *)objectNotation {
    NSError *error = nil;
    NSArray *tssPhotos = [TssPhotoBuilder tssPhotosFromJSON:objectNotation error:&error];
    
    if (error != nil) {
        [self.delegate fetchingTssPhotosFailedWithError:error];
    } else {
        [self.delegate didReceiveTssPhotos:tssPhotos];
    }
}

- (void)fetchingTssPhotosFailedWithError:(NSError *)error
{
    [self.delegate fetchingTssPhotosFailedWithError:error];
}

@end
