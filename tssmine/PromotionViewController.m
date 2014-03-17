//
//  PromotionViewController.m
//  TheSMUShop
//
//  Created by Bob Cao on 20/2/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "PromotionViewController.h"
#import "PromotionPFTableViewCell.h"

@interface PromotionViewController ()

@end

@implementation PromotionViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // Customize the table
        
        // The className to query on
        self.parseClassName = @"Promotion";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    //mark cell indentifier in storyboard
    static NSString *CellIdentifier = @"promotionCell";
    NSLog(@"%@", @"11");
    
    //assign indentifer
    PromotionPFTableViewCell *cell = (PromotionPFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //initilize with identifer
    if (cell == nil) {
        cell = (PromotionPFTableViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    [cell.promotionTitle setText:[object objectForKey:@"Title"]];
    [cell.promotionSubtitle setText:[object objectForKey:@"Subtitle"]];
    [cell.discount_slogan setText:[object objectForKey:@"discount_slogan"]];
    cell.promotionImage.file = [object objectForKey:@"img"];
    [cell.promotionImage loadInBackground];
    NSDate *expiry = [object objectForKey:@"expiry"];
    cell.expiryDate.text = [expiry description];
    NSLog(@"%@", [[object objectForKey:@"expiry"] class]);
    
    return cell;
}

@end
