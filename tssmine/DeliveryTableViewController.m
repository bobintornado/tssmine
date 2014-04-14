//
//  DeliveryTableViewController.m
//  mySMUShop
//
//  Created by Bob Cao on 16/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "DeliveryTableViewController.h"
#import "BillingDetailsTableViewController.h"
#import "PaymentTableViewController.h"
#import "MYSMUConstants.h"
#import "TSSShiping.h"
#import "PaymentCenter.h"

@interface DeliveryTableViewController ()

@property (strong, nonatomic) NSMutableArray *methods;
@property (strong, nonatomic) IBOutlet UITableView *methodTV;
@property (strong ,nonatomic) PaymentCenter *sharedCenter;

@end

@implementation DeliveryTableViewController

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
    self.sharedCenter = [PaymentCenter sharedCenter];
    self.title = @"Delivery Method";
    [self getShippingMethods];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)getShippingMethods{
    self.methods = [[NSMutableArray alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"%@index.php?route=%@&key=%@",ShopDomain,@"feed/web_api/shippingMethods",RESTfulKey,nil];
    
    //NSLog(@"and the calling url is .. %@",urlString);
    NSURL *productsURL = [NSURL URLWithString:urlString];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:productsURL] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"fetching shipping_methods data failed");
        } else {
            NSLog(@"start fetching shipping_methods data");
            NSError *localError = nil;
            id parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            
            if([parsedObject isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *results = parsedObject;
                //construct objects and pass to array
                NSLog(@"shipping_methods are dict");
                
                NSDictionary *methods = [results valueForKey:@"shipping_methods"];
                for (NSString *key in [methods allKeys]) {
                    NSDictionary *category = [methods valueForKey:key];
                    NSDictionary *quote = [category valueForKey:@"quote"];
                    for (NSString *key2 in [quote allKeys]) {
                        NSDictionary *method = [quote valueForKey:key2];
                        
                        TSSShiping *shiping = [[TSSShiping alloc] init];
                            
                        shiping.shippingcode = [method valueForKey:@"code"];
                        shiping.title = [method valueForKey:@"title"];
                        shiping.text = [method valueForKey:@"text"];
                            
                        [self.methods addObject:shiping];
                    }
                }
            } else {
                NSLog(@"what we get is not a kind of clss nsdictionary class");
            }
        }
        //reload data method
        [self.methodTV performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }];
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.sharedCenter.shippingcode = [[self.methods objectAtIndex:indexPath.row] shippingcode];
    
    //construct the post
    NSString * str = [NSString stringWithFormat:@"%@index.php?route=checkout/shipping_method/validate",ShopDomain];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:str]];
    [request setHTTPMethod:@"POST"];
    //Post string regarding billing information
    NSString *postString = [NSString stringWithFormat:@"shipping_method=%@&comment=", self.sharedCenter.shippingcode];
    
    [request setValue:[NSString stringWithFormat:@"%d", [postString length]] forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Billing infor validation failed");
        } else {
            NSError *localError = nil;
            id parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            if ([parsedObject isKindOfClass:[NSDictionary class]]) {
                NSLog(@"yes dict");
                //Need to pop validation errors
                if ([parsedObject valueForKey:@"error"] != nil) {
                    NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    //more beautification works needs here
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                                 message:strData
                                                                delegate:self
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:@"OK", nil];
                    [av performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
                }
            } else {
                [self performSelectorOnMainThread:@selector(payment) withObject:nil waitUntilDone:NO];
            }
        }
    }];
    
}

- (void)payment{    
    PaymentTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"payment"];
    [self.navigationController pushViewController:vc animated:YES];
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
    return [self.methods count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shippingMethods" forIndexPath:indexPath];
    // Configure the cell...
    
    TSSShiping *shiping = [self.methods objectAtIndex:indexPath.row];
    [cell.textLabel setText:[shiping title]];
    [cell.textLabel sizeToFit];
    NSString *cost = [NSString stringWithFormat:@"Delivery Cost: %@", [shiping text]];
    [cell.detailTextLabel setText:cost];
    
    return cell;
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
