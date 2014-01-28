//
//  ProductDetailViewController.m
//  tssmine
//
//  Created by Bob Cao on 23/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "ProductDetailViewController.h"

@interface ProductDetailViewController ()
@property (strong, nonatomic) IBOutlet PFImageView *productImageView;
@property (strong, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UILabel *price;

@end

@implementation ProductDetailViewController

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
    self.productImageView.file = [self.selectedProduct objectForKey:@"PreviewImage"];
    [self.productImageView loadInBackground];
    self.productName.text = [self.selectedProduct objectForKey:@"Name"];
    self.price.text = [NSString stringWithFormat:@"$ %@", [self.selectedProduct objectForKey:@"Price"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
