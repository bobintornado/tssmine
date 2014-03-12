//
//  SubCategoryViewController.m
//  mySMU
//
//  Created by Bob Cao on 4/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "SubCategoryViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MYSMUConstants.h"
#import "ProductListViewController.h"
#import "CartViewController.h"

@interface SubCategoryViewController ()

@end

@implementation SubCategoryViewController

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(shoppingCart)];
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
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    TSSCategories *cateogry = (TSSCategories *)[self.categories objectAtIndex:indexPath.row];

    //config the cell
    cell.textLabel.text = cateogry.name;
    [cell.textLabel sizeToFit];
    
    if ([cateogry.imageURLString isKindOfClass:[NSString class]])  {
        NSURL *imageURL = [NSURL URLWithString:cateogry.imageURLString];
        [cell.imageView setImageWithURL:imageURL];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *parentID = [self.categories[indexPath.row] categoryID];
    
    NSString *urlString = [NSString stringWithFormat:@"%@index.php?route=feed/web_api/%@&key=%@&id=%@",ShopDomain,@"getCategoriesByParentId",RESTfulKey,parentID];
    
    //NSLog(@"and the calling url is .. %@",urlString);
    NSURL *categoryURL = [NSURL URLWithString:urlString];
    
    //asking for information
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:categoryURL] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"fetching sub categories data failed");
        } else {
            NSError *localError = nil;
            id parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            
            if([parsedObject isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *results = parsedObject;
                if ([[results valueForKey:@"count"] isEqual:@0]) {
                    //initialize collection view
                    NSLog(@"and the count is %@", [results valueForKey:@"count"]);
                    [self performSelectorOnMainThread:@selector(pushProductListVC:) withObject:self.categories[indexPath.row] waitUntilDone:NO];
                    
                } else {
                    //initialize subcategory view
                    NSMutableArray *subCategories = [[NSMutableArray alloc] init];
                    //code for constructing new categories objects
                    for (NSObject *ob in [results valueForKey:@"categories"]){
                        TSSCategories *category = [[TSSCategories alloc] init];
                        [category setCategoryName:[ob valueForKey:@"name"] CategoryID:[ob valueForKey:@"category_id"] parentID:[ob valueForKey:@"parent_id"] andImageURLString:[ob valueForKey:@"image"]];
                        [subCategories addObject:category];
                    }
                    [self performSelectorOnMainThread:@selector(pushSubCategoryVC:) withObject:subCategories waitUntilDone:NO];
                }
            } else {
                NSLog(@"what we get is not a kind of clss nsdictionary class");
            }
        }
    }];
}

- (void)pushProductListVC:(TSSCategories *)category {
    ProductListViewController *pLVC = [self.storyboard instantiateViewControllerWithIdentifier:@"pLVC"];
    pLVC.category = category;
    [self.navigationController pushViewController:pLVC animated:YES];
}

- (void)pushSubCategoryVC:(NSMutableArray *)subCategories {
    //initialize
    SubCategoryViewController *subCategoriesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"subCategories"];
    //set sub categories
    subCategoriesVC.categories = [NSArray arrayWithArray:subCategories];

    [self.navigationController pushViewController:subCategoriesVC animated:YES];
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
