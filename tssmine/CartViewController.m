//
//  CartViewController.m
//  mySMU
//
//  Created by Bob Cao on 11/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "CartViewController.h"
#import "MYSMUConstants.h"

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Check Out" style:UIBarButtonItemStylePlain target:self action:@selector(checkOut)];
}

- (void)getProductsInCart {
    
    NSString *urlString = [NSString stringWithFormat:@"%@index.php?route=%@&key=%@",ShopDomain,@"feed/web_api/cart",RESTfulKey,nil];
    //NSLog(@"and the calling url is .. %@",urlString);
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
                NSLog(@"dict or not");
                NSDictionary *result = parsedObject;
                //construct objects and pass to array
                
                self.productsInCart = [[NSMutableArray alloc] init];
                
                for (NSObject *ob in [result valueForKey:@"products_in_cart"]){
                    [self.productsInCart addObject:ob];
                }
            } else {
                NSLog(@"what we get is not a kind of clss nsdictionary class");
            }
        }
        //NSLog(@"reload data");
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
    //static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    NSObject *ob = self.productsInCart[indexPath.row];
    
    [cell.textLabel setText:[ob valueForKey:@"Name"]];
    [cell.detailTextLabel setText:[ob valueForKey:@"quantity"]];
    
    // Configure the cell...
    
    return cell;
}


- (void)checkOut{
    
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
