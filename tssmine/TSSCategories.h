//
//  TSSCategories.h
//  mySMU
//
//  Created by Bob Cao on 3/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSSCategories : NSObject

@property NSString *name;
@property NSString *categoryID;
@property NSString *parentID;
@property NSString *imageURLString;


- (void)setCategoryName:(NSString *)name CategoryID:(NSString *)categoryID parentID:(NSString *)parentID andImageURLString:(NSString *)url;

@end
