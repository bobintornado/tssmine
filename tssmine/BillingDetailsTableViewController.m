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
#import "PaymentTableViewController.h"
#import "PaymentCenter.h"

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Payment" style:UIBarButtonItemStylePlain target:self action:@selector(paymentMethods)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.sharedCenter = [PaymentCenter sharedCenter];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)paymentMethods{
    //if pass all verificatons, then create order and proceed to payment
    PaymentTableViewController *pVC = [self.storyboard instantiateViewControllerWithIdentifier:@"payment"];
    [self.navigationController pushViewController:pVC animated:YES];
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
    return 5;
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
        c.inputField.placeholder = self.sharedCenter.firstName;
    } else if (indexPath.row == 1){
        InputTableViewCell *c = (InputTableViewCell *)cell;
        c.inputTitle.text = @"Last Name";
        c.inputField.placeholder = self.sharedCenter.lastName;
    } else if (indexPath.row == 2){
        InputTableViewCell *c = (InputTableViewCell *)cell;
        c.inputTitle.text = @"Email";
        c.inputField.placeholder = self.sharedCenter.email;
    } else if (indexPath.row == 3){
        InputTableViewCell *c = (InputTableViewCell *)cell;
        c.inputTitle.text = @"Telephone";
        c.inputField.placeholder = self.sharedCenter.telephone;
    } else {
        ChoseTableViewCell *c = (ChoseTableViewCell *)cell;
        c.choseLabel.text = @"I am a/an...";
        c.chosenValue.text = self.sharedCenter.salutation;
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
