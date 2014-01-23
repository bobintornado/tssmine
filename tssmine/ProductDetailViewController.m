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
    self.productImageView.file = [self.selectedProduct objectForKey:@"Picture"];
    [self.productImageView loadInBackground];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
