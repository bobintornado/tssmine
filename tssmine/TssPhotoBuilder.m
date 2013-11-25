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
            
            NSString *urlOfAnActualTssPhoto = tssPhotoDic[@"url"];
            NSURL *url = [[NSURL alloc] initWithString:urlOfAnActualTssPhoto];
            [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                
                NSDictionary *aTssPhotoJson = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
                
                TssPhoto *aTssPhoto = [[TssPhoto alloc] init];
                aTssPhoto = [aTssPhoto initWithDescription:aTssPhotoJson[@"description"] Owner:aTssPhotoJson[@"user_id"] Image:aTssPhotoJson[@"photo"] Created_at:aTssPhotoJson[@"created_at"]];
                [tssPhotos addObject:aTssPhoto];
            }];
        }
    }
    return tssPhotos;
};

@end
