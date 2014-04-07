//
//  BillingDetailsTableViewController.m
//  mySMUShop
//
//  Created by Bob Cao on 16/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "BillingDetailsTableViewController.h"
#import "InputTableViewCell.h"
#import "ChoseTableViewCell.h"
#import "SalutationTableViewController.h"
#import "DeliveryTableViewController.h"
#import "PaymentCenter.h"
#import "MYSMUConstants.h"

@interface BillingDetailsTableViewController ()

@property (strong, nonatomic) PaymentCenter *sharedCenter;

@end

@implementation BillingDetailsTableViewController

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
    self.title = @"Billing Details";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Delivery" style:UIBarButtonItemStylePlain target:self action:@selector(paymentMethods)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.sharedCenter = [PaymentCenter sharedCenter];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)paymentMethods{
    //Retrieve text field values from row
    
    
    //if pass all verificatons, then create order and proceed to payment
    //PaymentTableViewController *pVC = [self.storyboard instantiateViewControllerWithIdentifier:@"payment"];
    //[self.navigationController pushViewController:pVC animated:YES];
    
    //Using existing validation methods
    NSString * str = [NSString stringWithFormat:@"%@index.php?route=checkout/guest/validate",ShopDomain];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:str]];
    [request setHTTPMethod:@"POST"];
    //Post string regarding billing information
    NSString *postString = [NSString stringWithFormat:@"firstname=%@&lastname=%@&email=%@&telephone=%@&fax=&company=%@&company_id=&tax_id=&address_1=%@&address_2=&city=%@&postcode=%@&country_id=188&zone_id=0&shipping_address=1&customer_group_id=%@", self.sharedCenter.firstName, self.sharedCenter.lastName, self.sharedCenter.email, self.sharedCenter.telephone,self.sharedCenter.company, self.sharedCenter.address, @"Singapore", self.sharedCenter.postcode,self.sharedCenter.customer_group_id];
    
    NSLog(postString);
    
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
                NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"pass");
                [self performSelectorOnMainThread:@selector(Delivery) withObject:self waitUntilDone:NO];
            }
        }
    }];
}

- (void)Delivery{
    DeliveryTableViewController *dVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Delivery"];
    [self.navigationController pushViewController:dVC animated:YES];
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
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    if (indexPath.row == 4) {
        identifier = @"choseCell";
    } else {
        identifier = @"inputCell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        InputTableViewCell *c = (InputTableViewCell *)cell;
        c.inputTitle.text = @"First Name";
        c.inputField.placeholder = @"Your First Name";
        c.inputField.tag = 0;
        c.inputField.delegate = self;
    } else if (indexPath.row == 1){
        InputTableViewCell *c = (InputTableViewCell *)cell;
        c.inputTitle.text = @"Last Name";
        c.inputField.placeholder = @"Your Last Name";
        c.inputField.tag = 1;
        c.inputField.delegate = self;
    } else if (indexPath.row == 2){
        InputTableViewCell *c = (InputTableViewCell *)cell;
        c.inputTitle.text = @"Email";
        c.inputField.placeholder = @"For Sending Invoice";
        c.inputField.tag = 2;
        c.inputField.delegate = self;
    } else if (indexPath.row == 3){
        InputTableViewCell *c = (InputTableViewCell *)cell;
        c.inputTitle.text = @"Telephone";
        c.inputField.placeholder = @"88888888";
        c.inputField.tag = 3;
        c.inputField.delegate = self;
    } else if (indexPath.row == 4) {
        ChoseTableViewCell *c = (ChoseTableViewCell *)cell;
        c.choseLabel.text = @"I am a/an...";
        c.chosenValue.text = self.sharedCenter.salutation;
    } else if (indexPath.row == 5){
        InputTableViewCell *c = (InputTableViewCell *)cell;
        c.inputTitle.text = @"Address";
        c.inputField.placeholder = @"Your Address";
        c.inputField.tag = 4;
        c.inputField.delegate = self;
    } else if (indexPath.row == 6){
        InputTableViewCell *c = (InputTableViewCell *)cell;
        c.inputTitle.text = @"Post Code";
        c.inputField.placeholder = @"Post Code";
        c.inputField.tag = 5;
        c.inputField.delegate = self;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4) {
        SalutationTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SalutationVC"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 0:
            self.sharedCenter.firstName = textField.text;
            break;
            
        case 1:
            self.sharedCenter.lastName = textField.text;
            break;
            
        case 2:
            self.sharedCenter.email = textField.text;
            break;
            
        case 3:
            self.sharedCenter.telephone = textField.text;
            break;
            
        case 4:
            self.sharedCenter.address = textField.text;
            break;
            
        case 5:
            self.sharedCenter.postcode = textField.text;
            break;
    }
    return YES;
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
