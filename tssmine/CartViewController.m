//
//  CartViewController.m
//  mySMU
//
//  Created by Bob Cao on 11/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "CartViewController.h"
#import "MYSMUConstants.h"
#import "TSSCartTableViewCell.h"
#import "ProductInCart.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DeliveryTableViewController.h"
#import "CheckoutCenter.h"


@interface CartViewController ()

@property (strong, nonatomic) IBOutlet UITableView *pICTB;
@property NSMutableArray *productsInCart;

@end

@implementation CartViewController

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
   
    self.title = @"Cart";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Check Out" style:UIBarButtonItemStylePlain target:self action:@selector(checkOut)];
    [self getProductsInCart];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)getProductsInCart
{
    self.productsInCart = [[NSMutableArray alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"%@index.php?route=%@&key=%@",ShopDomain,@"feed/web_api/cart",RESTfulKey,nil];
    NSURL *cartURL = [NSURL URLWithString:urlString];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:cartURL] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"fetching products in cart data failed");
        } else {
            NSLog(@"start fetching product data");
            NSError *localError = nil;
            id parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            
            if([parsedObject isKindOfClass:[NSDictionary class]])
            {
                NSLog(@"it is dict");
                NSDictionary *result = parsedObject;
                //construct objects and pass to array
                
                for (NSObject *ob in [result valueForKey:@"products_in_cart"]){
                    ProductInCart *pic = [[ProductInCart alloc] init];
                    //configure paramaters
                    pic.key = [ob valueForKey:@"key"];
                    pic.name = [ob valueForKey:@"name"];
                    pic.thumb = [NSURL URLWithString:[ob valueForKey:@"thumb"]];
                    for (NSObject *obo in [ob valueForKey:@"option"]) {
                        pic.option_name = [obo valueForKey:@"name"];
                        pic.option_value = [obo valueForKey:@"value"];
                    }
                    pic.quantity = [ob valueForKey:@"quantity"];
                    pic.remove = [NSURL URLWithString:[ob valueForKey:@"remove"]];
                    //add object into array
                    [self.productsInCart addObject:pic];
                }
                
                ProductInCart* p = [[ProductInCart alloc] init];
                p.name = [result valueForKey:@"total"];
                [self.productsInCart addObject:p];
                CheckoutCenter *sharedCenter = [CheckoutCenter sharedCenter];
                sharedCenter.total = [[result valueForKey:@"amount"] substringFromIndex:1];
            } else {
                NSLog(@"what we get is not a kind of clss nsdictionary class");
            }
        }
        [self.pICTB performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.productsInCart count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cartCell";

    ProductInCart *p = self.productsInCart[indexPath.row];
    
    TSSCartTableViewCell *cell = (TSSCartTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [cell.image setImageWithURL:p.thumb];
    [cell.productName setText:p.name];
    
    if (p.quantity !=NULL) {
        NSString *q = [NSString stringWithFormat:@"Qty:%@",p.quantity];
        [cell.quantity setText:q];
    }
    
    if (p.option_name != NULL) {
        NSString *s = [NSString stringWithFormat:@"- %@ : %@",p.option_name, p.option_value];
        [cell.optionValue setText:s];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)checkOut{
    if ([self.productsInCart count] == 1) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Cart"
                                                     message:@"You Cart Is Empty!"
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"OK", nil];
        [av show];
    } else {
        DeliveryTableViewController *dVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Delivery"];
        [self.navigationController pushViewController:dVC animated:YES];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [self.productsInCart count]-1) {
        return NO;
    }
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data sources
        if ([self.productsInCart count] >= 1) {
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            ProductInCart *rp = self.productsInCart[indexPath.row];
            NSString *urlString = [NSString stringWithFormat:@"%@index.php?route=feed/web_api/%@&key=%@&remove=%@",ShopDomain,@"removeProduct",RESTfulKey,rp.key];
            //NSLog(@"and the calling url is .. %@",urlString);
            NSURL *removeURL = [NSURL URLWithString:urlString];
            [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:removeURL] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                if (error) {
                    NSLog(@"removing product failed");
                } else {
                    NSLog(@"succesfully remove product");
                    [self getProductsInCart];
                }
            }];
            [self.productsInCart removeObjectAtIndex:[indexPath row]];
            [tableView endUpdates];
        }
    }
}


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
