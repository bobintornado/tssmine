//
//  SnapFeedsViewController.m
//  tssmine
//
//  Created by Bob Cao on 7/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "SnapFeedsViewController.h"
#import "snapFeedTableViewCell.h"
#import "SnapDetailViewController.h"
#import "TSSUtility.h"

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
    
    //mark cell indentifier in storyboard
    static NSString *CellIdentifier = @"snapCell";
    
    //assign indentifer
    snapFeedTableViewCell *cell = (snapFeedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //initilize with identifer
    if (cell == nil) {
        cell = [[snapFeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    //query cell statistics
    PFQuery *snapLikeCount = [[PFQuery alloc] initWithClassName:@"ActivityLike"];
    [snapLikeCount whereKey:@"snapPhoto" equalTo:object];
    [snapLikeCount countObjectsInBackgroundWithBlock:^(int number, NSError *error){
        cell.snapStatsLabel.text = [NSString stringWithFormat:@"%d likes 0 comments", number];
    }];
    
    // Configure the cell
    cell.snapPhotoObject = object;
    cell.snapPhoto.file = [object objectForKey:self.imageKey];
    [cell.snapPhoto loadInBackground];
    
    //make button responsive
    for (id obj in cell.subviews)
    {
        if ([NSStringFromClass([obj class]) isEqualToString:@"UITableViewCellScrollView"])
        {
            UIScrollView *scroll = (UIScrollView *) obj;
            scroll.delaysContentTouches = NO;
            break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    SnapDetailViewController *snapDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"snapDetailVC"];
    
    [self.navigationController pushViewController:snapDetailVC animated:YES];
}

@end
