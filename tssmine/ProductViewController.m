//
//  ProductViewController.m
//  mySMU
//
//  Created by Bob Cao on 11/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "ProductViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MYSMUConstants.h"

@interface ProductViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *productImageView;
@property (strong, nonatomic) IBOutlet UILabel *pTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *pPriceLabel;
@property (strong, nonatomic) IBOutlet UIButton *optionButton;
@property (strong, nonatomic) IBOutlet UIButton *ATCButton;
@property (strong, nonatomic) NSArray *options;
@property (strong, nonatomic) IBOutlet UIScrollView *productScrollView;

@end

@implementation ProductViewController

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
    [self.productImageView setImageWithURL:self.product.thumbURL];
    self.pTitleLabel.text = self.product.name;
    self.pPriceLabel.text = self.product.price;
    [self updateProductDetails];
    self.productScrollView.delaysContentTouches = NO;
}

- (void)updateProductDetails{
    NSString *urlString = [NSString stringWithFormat:@"%@index.php?route=%@&key=%@&id=%@",ShopDomain,@"feed/web_api/product",RESTfulKey,self.product.productID,nil];
    //NSLog(@"and the calling url is .. %@",urlString);
    NSURL *categoryURL = [NSURL URLWithString:urlString];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:categoryURL] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"fetching selected product data failed");
        } else {
            NSLog(@"start fetching product data");
            NSError *localError = nil;
            id parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            
            if([parsedObject isKindOfClass:[NSDictionary class]])
            {
                NSLog(@"dict or not");
                NSDictionary *result = parsedObject;
                //construct objects and pass to array
                
                NSString *imgStr = [[result valueForKey:@"product"] valueForKey:@"image"];
                [self.productImageView setImageWithURL:[NSURL URLWithString:imgStr]];
                
                NSMutableArray *ops = [[NSMutableArray alloc] init];
                for (NSObject *ob in [[result valueForKey:@"product"] valueForKey:@"options"]) {
                    [ops addObject:ob];
                }
                
                if ([ops count] != 0) {
                    NSArray *op = ops[0];
                    
                    
                    [self.optionButton setTitle:[op valueForKey:@"name"] forState:UIControlStateNormal];
                    
                    NSLog([op valueForKey:@"name"]);
                    
                    self.options = [op valueForKey:@"option_value"];
                }
            } else {
                NSLog(@"what we get is not a kind of clss nsdictionary class");
            }
        }
        //NSLog(@"reload data");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addToCart:(id)sender {
    
}

@end
