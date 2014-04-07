//
//  SalutationTableViewController.m
//  mySMUShop
//
//  Created by Bob Cao on 17/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "SalutationTableViewController.h"
#import "PaymentCenter.h"

@interface SalutationTableViewController ()

@property (strong, nonatomic) PaymentCenter *sharedCenter;

@end

@implementation SalutationTableViewController

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
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.sharedCenter = [PaymentCenter sharedCenter];
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
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SalutationTVCell" forIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.row == 0) {
        [cell.textLabel setText:@"Current Student"];
    } else if (indexPath.row == 1){
        [cell.textLabel setText:@"Alumni"];
    } else if (indexPath.row == 2){
        [cell.textLabel setText:@"Faculty"];
    } else if (indexPath.row == 3){
        [cell.textLabel setText:@"Staff"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController popViewControllerAnimated:YES];
    if (indexPath.row == 0) {
        self.sharedCenter.salutation = @"Current Student";
        self.sharedCenter.customer_group_id = @"1";
    } else if (indexPath.row == 1){
        self.sharedCenter.salutation = @"Alumni";
        self.sharedCenter.customer_group_id = @"3";
    } else if (indexPath.row == 2){
        self.sharedCenter.salutation = @"Faculty";
        self.sharedCenter.customer_group_id = @"4";
    } else if (indexPath.row == 3){
        self.sharedCenter.salutation = @"Staff";
        self.sharedCenter.customer_group_id = @"5";
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
