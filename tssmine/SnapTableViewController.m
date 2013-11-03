//
//  SnapTableViewController.m
//  tssmine
//
//  Created by Bob Cao on 2/11/13.
//  Copyright (c) 2013 Bob Cao. All rights reserved.
//

#import "SnapTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TssPhotoCell.h"

@interface SnapTableViewController ()

@end

@implementation SnapTableViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SnapIdentifier = @"SnapIdentifier";
    TssPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:SnapIdentifier];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ImageCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (TssPhotoCell *)currentObject;
                break;
            }
        }
    }
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    [items addObject:@"http://tssphotos.s3.amazonaws.com/photos/photos/000/000/001/original/2013-10-31_19.54.00.jpg?1383409321"];
    [items addObject:@"http://tssphotos.s3.amazonaws.com/photos/photos/000/000/002/original/2013-09-03_17.13.23.jpg?1383416252"];

    [items addObject:@"http://tssphotos.s3.amazonaws.com/photos/photos/000/000/003/original/2013-01-29_09.00.10.jpg?1383416342"];

    [cell.tssPhoto setImageWithURL:[NSURL URLWithString:[items objectAtIndex:indexPath.row]]  placeholderImage:[UIImage imageNamed:@"Hisoka.jpg"]];
    
    cell.tssPhotoLable.text = @"Post by bob at 05:00am";
    
    return cell;
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
