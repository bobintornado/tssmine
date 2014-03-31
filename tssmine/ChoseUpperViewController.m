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
#import "NSString+HTML.h"
#import "TSSProduct.h"
#import "TSSOption.h"
#import "TSSOptionValue.h"
#import "MYSMUConstants.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface ChoseUpperViewController ()

@property (strong,nonatomic) NSMutableArray *products;
@property (strong, nonatomic) IBOutlet UICollectionView *upperCollection;

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
    self.title = @"Chose Top";
    self.products = [[NSMutableArray alloc] init];
    //implement this if the json is huge
    //[NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@index.php?route=%@&key=%@&part=%@",ShopDomain,@"feed/web_api/customize",RESTfulKey,@"top",nil];
    
    NSURL *productsURL = [NSURL URLWithString:urlString];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:productsURL] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"fetching products data failed");
        } else {
            NSLog(@"start fetching products data");
            NSError *localError = nil;
            id parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            
            if([parsedObject isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *results = parsedObject;
                //construct objects and pass to array
                NSLog(@"products is dict");
                for (NSObject *ob in [results valueForKey:@"products"]){
                    TSSProduct *pr = [[TSSProduct alloc] init];
                    
                    pr.productID = [ob valueForKey:@"id"];
                    pr.name =  [[ob valueForKey:@"name"] stringByConvertingHTMLToPlainText];
                    
                    NSString *urlText = [[ob valueForKey:@"thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    pr.thumbURL = [NSURL URLWithString:urlText];
                    urlText = [[ob valueForKey:@"image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    pr.image = [NSURL URLWithString: urlText];
                    pr.pDescription = [[ob valueForKey:@"description"] stringByConvertingHTMLToPlainText];
                    pr.price = [NSString stringWithFormat:@"%@",[ob valueForKey:@"pirce"]];
                    
                    TSSOption *pop = [[TSSOption alloc] init];
                    
                    for (NSObject *op in [ob valueForKey:@"options"]) {
                        NSLog(@"runing1");
                        pop.product_option_id = [op valueForKey:@"product_option_id"];
                        pop.optionId = [op valueForKey:@"option_id"];
                        pop.name = [op valueForKey:@"name"];
                        
                        pop.optionValues = [[NSMutableArray alloc] init];
                        
                        if ([[op valueForKey:@"option_value"] isKindOfClass:[NSArray class]]) {
                            for (NSObject *opv in [op valueForKey:@"option_value"]){
                                TSSOptionValue *v = [[TSSOptionValue alloc] init];
                                v.product_option_value_id = [opv valueForKey:@"product_option_value_id"];
                                v.option_value_id = [opv valueForKey:@"option_value_id"];
                                v.name = [opv valueForKey:@"name"];
                                [pop.optionValues addObject:v];
                            }
                        } else {
                            NSLog(@"non array option");
                        }
                    }
                    pr.option = pop;
                    
                    [self.products addObject:pr];
                }
            } else {
                NSLog(@"what we get is not a kind of clss nsdictionary class");
            }
        }
        [self.upperCollection performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
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
    
    TSSProduct *object = (TSSProduct *)[_products objectAtIndex:indexPath.row];
    
    NSLog(@"url is %@", [[object image] absoluteString]);
    
    [cell.productImageView setImageWithURL:object.image usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //disselect and get the product
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    TSSProduct *product = [_products objectAtIndex:indexPath.row];
    
    //assign the product to center
    StyleCenter *sharedCenter = [StyleCenter sharedCenter];
    sharedCenter.upper = product;
    
    [self performSegueWithIdentifier:@"choseUnder" sender:self];
}

@end
