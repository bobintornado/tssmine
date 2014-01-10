//
//  SnapFeedsViewController.m
//  tssmine
//
//  Created by Bob Cao on 7/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "SnapFeedsViewController.h"
#import "snapFeedTableViewCell.h"

@interface SnapFeedsViewController ()
@property (strong, nonatomic) IBOutlet UITableView *feedsTableView;

@end

@implementation SnapFeedsViewController

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
        self.parseClassName = @"snap";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"snapTitle";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        self.imageKey = @"snapPicture";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
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
    static NSString *CellIdentifier = @"snapCell";
    
    tableView = self.feedsTableView;
    
    snapFeedTableViewCell *cell = (snapFeedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[snapFeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    //cell.snapTitle.text = [object objectForKey:self.textKey];
    cell.snapPhotoObject = object;
    cell.snapPhoto.file = [object objectForKey:self.imageKey];
    
    [cell.snapPhoto loadInBackground];
    
    return cell;
}

@end
