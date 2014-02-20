//
//  BazaarViewController.m
//  TheSMUShop
//
//  Created by Bob Cao on 20/2/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "BazaarViewController.h"
#import "BazaarPFTableViewCell.h"

@interface BazaarViewController ()

@property (strong, nonatomic) IBOutlet UINavigationItem *bazaarUINav;

@end

@implementation BazaarViewController

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
	// Do any additional setup after loading the view
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
        self.parseClassName = @"SHItem";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
         NSLog(@"%@", @"42");
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    //mark cell indentifier in storyboard
    static NSString *CellIdentifier = @"bazaarTBV";
    NSLog(@"%@", @"22");
    
    //assign indentifer
    BazaarPFTableViewCell *cell = (BazaarPFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //initilize with identifer
    if (cell == nil) {
        cell = (BazaarPFTableViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    cell.itemImg.file = [object objectForKey:@"img"];
    [cell.itemImg loadInBackground];
    cell.itemTitle.text = [object objectForKey:@"title"];
    cell.itemDes.editable = false;
    cell.itemDes.text = [object objectForKey:@"description"];
    cell.itemPrice.text = [NSString stringWithFormat:@"$%@", [object objectForKey:@"price"]];
    cell.itemContact.text = [NSString stringWithFormat:@"HP: %@", [object objectForKey:@"phone"]];
    
    return cell;
}

- (IBAction)pressCompose:(id)sender {
}

@end
