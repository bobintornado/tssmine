//
//  TSSCategories.m
//  mySMU
//
//  Created by Bob Cao on 3/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "TSSCategories.h"

@implementation TSSCategories

-(void)setCategoryName:(NSString *)name CategoryID:(NSString *)categoryID parentID:(NSString *)parentID andImageURLString:(NSString *)url{
    self.name = name;
    self.categoryID = categoryID;
    self.parentID = parentID;
    self.imageURLString = url;
}

@end
