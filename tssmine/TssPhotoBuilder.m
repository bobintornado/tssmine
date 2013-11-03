//
//  TssPhotoBuilder.m
//  tssmine
//
//  Created by Bob Cao on 4/11/13.
//  Copyright (c) 2013 Bob Cao. All rights reserved.
//

#import "TssPhotoBuilder.h"
#import "TssPhoto.h"

@implementation TssPhotoBuilder

+ (NSArray *)tssPhotosFromJSON:(NSData *)objectNotation error:(NSError **)error{
    NSError *localError = nil;
    
    NSArray *tssPhotoArray = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *tssPhotos = [[NSMutableArray alloc] init];
    
    if (!tssPhotoArray){
        NSLog(@"Error parsing JSON: %@", localError);
    } else {
        for(NSDictionary *tssPhotoDic in tssPhotoArray) {
            TssPhoto *aTssPhoto = [[TssPhoto alloc] init];
            for (NSString *key in tssPhotoDic) {
                //this part of code needed to further understood -- mark by Bob
                if ([TssPhoto respondsToSelector:NSSelectorFromString(key)]) {
                    [TssPhoto setValue:[tssPhotoDic valueForKey:key] forKey:key];
                }
            }
            [tssPhotos addObject:aTssPhoto];
        }
    }
    return tssPhotos;
};

@end
