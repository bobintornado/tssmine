//
//  ProductDetailViewController.m
//  tssmine
//
//  Created by Bob Cao on 23/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "webPaymentViewController.h"

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
    self.price.text = [NSString stringWithFormat:@"SGD $ %@", [self.selectedProduct objectForKey:@"Price"]];
    
    //adding Title
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = @"Product";
    
    //set left button for cancel
    UIBarButtonItem *leftCancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    //set right button as the sharing action button
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareProduct)];
    
    //Adding two buttons
    navItem.leftBarButtonItem = leftCancelButton;
    navItem.rightBarButtonItem = rightButton;
    self.navigationController.navigationBar.items = @[ navItem ];
    //self.quizResultNavBar.items =
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"webpurchase"])
    {
        // Get reference to the destination view controller
        webPaymentViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.fullURL = [self.selectedProduct objectForKey:@"Link"];
    }
}

@end
