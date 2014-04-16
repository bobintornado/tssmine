//
//  PaymentTableViewController.m
//  mySMUShop
//
//  Created by Bob Cao on 17/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "PaymentTableViewController.h"
#import "PaymentCenter.h"
#import "MYSMUConstants.h"
#import "TSSPaymentMethod.h"

@interface PaymentTableViewController ()

@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;
@property (nonatomic, strong) PaymentCenter *sharedCenter;
@property (strong, nonatomic) NSMutableArray *methods;
@property (strong, nonatomic) IBOutlet UITableView *paymentTV;

@end

@implementation PaymentTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _payPalConfiguration = [[PayPalConfiguration alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Start out working with the test environment! When you are ready, switch to PayPalEnvironmentProduction.
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentSandbox];
}

- (void)pay{
    self.sharedCenter = [PaymentCenter sharedCenter];
    //confirm order
    //construct the request to get order id
    NSString *urlString = [NSString stringWithFormat:@"%@index.php?route=%@&key=%@",ShopDomain,@"feed/web_api/confirm",RESTfulKey,nil];
    
    NSURL *confirm = [NSURL URLWithString:urlString];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:confirm] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"confirmatin failed");
        } else {
            NSLog(@"start confirming");
            NSError *localError = nil;
            id parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            if([parsedObject isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *results = parsedObject;
                self.sharedCenter.custom = [results valueForKey:@"custom"];
                NSLog(@"id is %@",self.sharedCenter.custom);
                NSArray *a = [results valueForKey:@"totals"];
                NSLog(@"total is %@",[[a objectAtIndex:[a count]-1] valueForKey:@"text"]);
                self.sharedCenter.total = [[[a objectAtIndex:[a count]-1] valueForKey:@"text"] substringFromIndex:1];
            } else {
                NSLog(@"what we get is not a kind of clss nsdictionary class");
            }
        }
        [self performSelectorOnMainThread:@selector(pushPayView) withObject:nil waitUntilDone:NO];
    }];
}

- (void)pushPayView{
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    // Amount, currency, and description
    payment.amount = [[NSDecimalNumber alloc] initWithString:self.sharedCenter.total];
    payment.currencyCode = @"SGD";
    payment.shortDescription = @"The SMU Shop Products";
    payment.intent = PayPalPaymentIntentSale;
    if (!payment.processable) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Payment"
                                                     message:@"Invalid Payment Information"
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"OK", nil];
        [av show];
    } else {
        PayPalPaymentViewController *paymentViewController;
        paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment configuration:self.payPalConfiguration delegate:self];
        
        // Present the PayPalPaymentViewController.
        [self presentViewController:paymentViewController animated:YES completion:nil];
    }
}
#pragma mark - PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(PayPalPayment *)completedPayment {
    // Payment was processed successfully; send to server for verification and fulfillment.
    [self verifyCompletedPayment:completedPayment];
    
    // Dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)verifyCompletedPayment:(PayPalPayment *)completedPayment {
    
    // Send confirmation to your server; your server should verify the proof of payment
    // and give the user their goods or services. If the server is not reachable, save
    // the confirmation and try again later.
    //checkout success
    NSString *urlString = [NSString stringWithFormat:@"%@index.php?route=%@&key=%@",ShopDomain,@"feed/web_api/checkoutSuccess",RESTfulKey,nil];

    NSURL *confirm = [NSURL URLWithString:urlString];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:confirm] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"checkout success failed");
        } else {
            NSLog(@"start clearing up stuff");
            NSError *localError = nil;
            id parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            if([parsedObject isKindOfClass:[NSDictionary class]])
            {
                //do nothing
            } else {
                NSLog(@"what we get is not a kind of clss nsdictionary class");
            }
        }
    }];
    
    //call back to server for paypal verification
    NSData *confirmation = [NSJSONSerialization dataWithJSONObject:completedPayment.confirmation options:0 error:nil];
    NSError* error;
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:confirmation options:kNilOptions error:&error];
    NSString *paymentId= [[dict valueForKey:@"response"] valueForKey:@"id"];
    
    //construct the post
    NSString * str = [NSString stringWithFormat:@"%@index.php?route=feed/web_api/paypalCallback",ShopDomain];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:str]];
    [request setHTTPMethod:@"POST"];
    
    //Post string regarding verfication information
    NSString *postString = [NSString stringWithFormat:@"confirmation=%@&custom=%@",paymentId,self.sharedCenter.custom];
    
    [request setValue:[NSString stringWithFormat:@"%d", [postString length]] forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Payment infor validation failed");
        } else {
            NSError *localError = nil;
            id parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            if ([parsedObject isKindOfClass:[NSDictionary class]]) {
                NSLog(@"yes dict");
            } else {
                NSLog(@"not dict");
            }
        }
    }];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    // The payment was canceled; dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Payment Methods";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.sharedCenter = [PaymentCenter sharedCenter];
    [self paymentMethods];
}

- (void)paymentMethods{
    
    self.methods = [[NSMutableArray alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"%@index.php?route=%@&key=%@",ShopDomain,@"feed/web_api/getPaymentMethods",RESTfulKey,nil];
    NSURL *cartURL = [NSURL URLWithString:urlString];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:cartURL] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"fetching payment_methods data failed");
        } else {
            NSLog(@"start fetching payment_methods data");
            NSError *localError = nil;
            id parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            
            if([parsedObject isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *results = parsedObject;
                //construct objects and pass to array
                NSLog(@"payment_methods are dict");
                
                NSDictionary *methods = [results valueForKey:@"payment_methods"];
                for (NSString *key in [methods allKeys]) {
                    NSDictionary *method = [methods valueForKey:key];
                    TSSPaymentMethod *m = [[TSSPaymentMethod alloc] init];
                    m.methodCode = [method valueForKey:@"code"];
                    m.title = [method valueForKey:@"title"];
                    [self.methods addObject:m];
                }
                
                NSLog(@"payment dict is %@", results);
            } else {
                NSLog(@"what we get is not a kind of clss nsdictionary class");
            }
        }
        [self.paymentTV performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
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
    return [self.methods count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"paymentCell" forIndexPath:indexPath];
    
    // Configure the cell...
    TSSPaymentMethod *m = [self.methods objectAtIndex:indexPath.row];
    [cell.textLabel setText:[m title]];
    [cell.textLabel sizeToFit];
    return cell;
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        NSLog(@"Cancel");
    } else if (buttonIndex == 2){
        //click for information
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://shop.smu.edu.sg/store/index.php?route=information/information&information_id=6"]];
    } else if (buttonIndex == 1) {
        NSLog(@"Agree");
        
        //construct post for saving payment method to session
        //construct the post
        NSString * str = [NSString stringWithFormat:@"%@index.php?route=checkout/payment_method/validate",ShopDomain];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:str]];
        [request setHTTPMethod:@"POST"];
        //Post string regarding billing information
        NSString *postString = [NSString stringWithFormat:@"payment_method=%@&comment=&agree=1",self.sharedCenter.payment_method];
        
        [request setValue:[NSString stringWithFormat:@"%d", [postString length]] forHTTPHeaderField:@"Content-length"];
        
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (error) {
                NSLog(@"Payment infor validation failed");
            } else {
                NSError *localError = nil;
                id parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
                if ([parsedObject isKindOfClass:[NSDictionary class]]) {
                    
                    NSLog(@"yes dict");
                    //Need to pop validation errors
                    if ([parsedObject valueForKey:@"error"] != nil) {
                        
                        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Oops, Some Error Occured" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                        
                        [av performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
                    }
                } else {
                    [self performSelectorOnMainThread:@selector(pay) withObject:nil waitUntilDone:NO];
                }
            }
        }];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    self.sharedCenter.payment_method = [[self.methods objectAtIndex:indexPath.row] methodCode];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Delivery Information"
                                                     message:@"By Clicking On Agree, You agree with with all of our terms and conditions applied. For more information please click on Terms & Conditions button below."
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"Agree", @"Terms & Conditions",nil];
    [av show];
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
