//
//  ProductsCollectionViewController.h
//  tssmine
//
//  Created by Bob Cao on 20/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductsCollectionViewController : UICollectionViewController <UICollectionViewDataSource>

@property (strong,nonatomic) PFObject *selectedCategory;

@end
