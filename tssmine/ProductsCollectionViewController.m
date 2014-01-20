//
//  ProductsCollectionViewController.m
//  tssmine
//
//  Created by Bob Cao on 20/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "ProductsCollectionViewController.h"
#import "productCollectionCell.h"

@interface ProductsCollectionViewController ()

@property (strong,nonatomic) NSArray *productPhotos;

@end

@implementation ProductsCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = [self.selectedCategory objectForKey:@"Name"];
    PFQuery *query = [PFQuery queryWithClassName:@"TSSProduct"];
    [query whereKey:@"Category" equalTo:self.selectedCategory];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _productPhotos = objects;
        [self.collectionView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _productPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"productCell";
    productCollectionCell *cell = (productCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    PFObject *object = (PFObject *)[_productPhotos objectAtIndex:indexPath.row];
    cell.image.file = [object objectForKey:@"Picture"];
    [cell.image loadInBackground];
    return cell;
}

@end
