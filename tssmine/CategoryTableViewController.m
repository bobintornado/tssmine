//
//  CategoryTableViewController.m
//  tssmine
//
//  Created by Bob Cao on 19/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "CategoryTableViewCell.h"
#import "ProductsCollectionViewController.h"

@interface CategoryTableViewController ()

@end

@implementation CategoryTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // Customize the table
        
        // The className to query on
        self.parseClassName = @"Category";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"Name";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        self.imageKey = @"Picture";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = NO;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
        PFQuery *query = [PFQuery queryWithClassName:@"Category"];
        self.objectsPerPage = [query countObjects];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    //mark cell indentifier in storyboard
    static NSString *CellIdentifier = @"categoryCell";
    
    //assign indentifer
    CategoryTableViewCell *cell = (CategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //initilize with identifer
    if (cell == nil) {
        cell = [[CategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //configure the cell
    cell.categoryObject = object;
    cell.categoryImage.file = [object objectForKey:@"Picture"];
    [cell.categoryImage loadInBackground];
    cell.CategoryName.text = [object objectForKey:@"Name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ProductsCollectionViewController *productsCVC = [self.storyboard instantiateViewControllerWithIdentifier:@"productsCollectionView"];
    
    //get the object from the cell
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    CategoryTableViewCell *cell = (CategoryTableViewCell *)selectedCell;
    
    //pass the category object from cell to detination view controller
    productsCVC.selectedCategory = cell.categoryObject;
    
    [self.navigationController pushViewController:productsCVC animated:YES];
}

@end
