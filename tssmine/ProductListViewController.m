//
//  ProductListViewController.m
//  mySMU
//
//  Created by Bob Cao on 9/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "ProductListViewController.h"
#import "MYSMUConstants.h"
#import "TSSProduct.h"
#import "TSSProductCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ProductViewController.h"
#import "CartViewController.h"
#import "TSSOption.h"
#import "TSSOptionValue.h"

@interface ProductListViewController ()

@property (strong, nonatomic) IBOutlet UITableView *prListTableView;
@property NSMutableArray *products;
@property NSMutableArray *ops;


@end

@implementation ProductListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.ops = [[NSMutableArray alloc] init];
    
    [self getProducts];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cart.png"] style:UIBarButtonItemStylePlain target:self action:@selector(shoppingCart)];
    self.navigationItem.title = self.category.name;
    //remove extra rows in the end of the table
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)getProducts{
    self.products = [[NSMutableArray alloc] init];
    //implement this if the json is huge
    //[NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@index.php?route=%@&key=%@&category=%@",ShopDomain,@"feed/web_api/products",RESTfulKey,self.category.categoryID,nil];
    
    //NSLog(@"and the calling url is .. %@",urlString);
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
                    pr.name = [ob valueForKey:@"name"];
                    
                    NSString *urlText = [[ob valueForKey:@"thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    pr.thumbURL = [NSURL URLWithString:urlText];
                    urlText = [[ob valueForKey:@"image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    pr.image = [NSURL URLWithString: urlText];
                    pr.pDescription = [ob valueForKey:@"description"];
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
        NSLog(@"reload products data");
        [self.prListTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"products list view cell for index called");
    
    static NSString *CellIdentifier = @"pProductCell";
    TSSProductCell *cell = (TSSProductCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    TSSProduct *pr = self.products[indexPath.row];
    
    [cell.pThumb setImageWithURL:pr.thumbURL];

    
    cell.pTitle.text =pr.name;
    cell.pPrice.text = [NSString stringWithFormat:@"SGD %@", pr.price];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TSSProduct *product = self.products[indexPath.row];
    
    ProductViewController *pVC = [self.storyboard instantiateViewControllerWithIdentifier:@"productDetailView"];
    
    pVC.product = product;
    
    [self.navigationController pushViewController:pVC animated:YES];
}

- (void)shoppingCart{
    CartViewController *cVC = [self.storyboard instantiateViewControllerWithIdentifier:@"cart"];
    [self.navigationController pushViewController:cVC animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
