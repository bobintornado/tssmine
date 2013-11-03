//
//  TssPhotoManagerDelegate.h
//  tssmine
//
//  Created by Bob Cao on 4/11/13.
//  Copyright (c) 2013 Bob Cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TssPhotoManagerDelegate <NSObject>

- (void)didReceiveTssPhotos:(NSArray *)groups;
- (void)fetchingTssPhotosFailedWithError:(NSError *)error;

@end

