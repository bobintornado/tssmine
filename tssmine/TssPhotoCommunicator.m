//
//  TssPhotoCommunicator.m
//  tssmine
//
//  Created by Bob Cao on 4/11/13.
//  Copyright (c) 2013 Bob Cao. All rights reserved.
//

#import "TssPhotoCommunicator.h"
#import "TssPhotoCommunicatorDelegate.h"

@implementation TssPhotoCommunicator

- (void)retrieveAll{
    NSURL *url = [[NSURL alloc] initWithString:@"http://tss-back-end.herokuapp.com/photos.json"];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            [self.delegate fetchingTssPhotosFailedWithError:error];
        } else {
            [self.delegate receivedTssPhotosJSON:data];
        }
    }];
}

@end
