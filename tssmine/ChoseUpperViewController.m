//
//  ChoseUpperViewController.m
//  TheSMUShop
//
//  Created by Bob Cao on 28/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "ChoseUpperViewController.h"
#import "CustomizeUICollectionViewCell.h"
#import "StyleCenter.h"

@interface ChoseUpperViewController ()

@property (strong,nonatomic) NSArray *products;

@end

@implementation ChoseUpperViewController

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
    self.title = @"Chose Upper";
    PFQuery *query = [PFQuery queryWithClassName:@"TSSProduct"];
    [query whereKey:@"Position" equalTo:@1];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.products = objects;
        [self.collectionView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"customizeCollectionCell";
    CustomizeUICollectionViewCell *cell = (CustomizeUICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    PFObject *object = (PFObject *)[_products objectAtIndex:indexPath.row];
    
    //configure the cell
    cell.productImage.file = [object objectForKey:@"ThumbnailImage"];
    [cell.productImage loadInBackground];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //disselect and get the product
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    PFObject *product = [_products objectAtIndex:indexPath.row];
    
    //assign the product to center
    StyleCenter *sharedCenter = [StyleCenter sharedCenter];
    sharedCenter.upper = product;
    
    [self performSegueWithIdentifier:@"choseUnder" sender:self];
}

@end
