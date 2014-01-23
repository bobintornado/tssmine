//
//  ProductsCollectionViewController.m
//  tssmine
//
//  Created by Bob Cao on 20/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "ProductsCollectionViewController.h"
#import "productCollectionCell.h"
#import "ProductDetailViewController.h"

@interface ProductsCollectionViewController ()

@property (strong,nonatomic) NSArray *products;

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
        _products = objects;
        [self.collectionView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"productCell";
    productCollectionCell *cell = (productCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    PFObject *object = (PFObject *)[_products objectAtIndex:indexPath.row];
    
    //configure the cell
    cell.image.file = [object objectForKey:@"Picture"];
    [cell.image loadInBackground];
    cell.priceLabel.text = [NSString stringWithFormat:@"$ %@", [object objectForKey:@"Price"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    PFObject *product = [_products objectAtIndex:indexPath.row];
    ProductDetailViewController *pdVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductDeatil"];
    pdVC.selectedProduct = product;
    [self.navigationController pushViewController:pdVC animated:YES];
}

@end
