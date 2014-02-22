//
//  AnnouncementViewController.m
//  mySMU
//
//  Created by Bob Cao on 21/2/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "AnnouncementViewController.h"
#import "AnnouncementCell.h"

@interface AnnouncementViewController ()

@end

@implementation AnnouncementViewController

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
        self.parseClassName = @"Announcement";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    //mark cell indentifier in storyboard
    static NSString *CellIdentifier = @"announcement";
    NSLog(@"%@", @"11");
    
    //assign indentifer
    AnnouncementCell *cell = (AnnouncementCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //initilize with identifer
    if (cell == nil) {
        cell = (AnnouncementCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    cell.title.text = [object objectForKey:@"title"];
    cell.faulty.text = [object objectForKey:@"Faulty"];
    NSDate *date = [object objectForKey:@"AnnounDate"];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM-dd-yyyy"];
    cell.announcementDate.text = [format stringFromDate:date];
    cell.announcementText.editable = false;
    cell.announcementText.text = [object objectForKey:@"detail"];
    NSString *fileName = [NSString stringWithFormat:@"%@.png",
                         [object objectForKey:@"Faulty"]];
    UIImage *image = [UIImage imageNamed:fileName];
    cell.symbol.image = image;
    
    NSLog(@"%@", @"AAA");
    
    return cell;
}

@end
