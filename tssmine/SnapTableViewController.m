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
#import "TssPhoto.h"
#import "TssPhotosManager.h"
#import "TssPhotoCommunicator.h"

@interface SnapTableViewController () <TssPhotoManagerDelegate> {
    NSArray *_tssPhotos;
    TssPhotosManager *_manager;
   
}
@property (assign, nonatomic) BOOL ascending;

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
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _manager = [[TssPhotosManager alloc] init];
    _manager.communicator = [[TssPhotoCommunicator alloc] init];
    
    _manager.communicator.delegate = _manager;
    _manager.delegate = self;
    
    [_manager fetchTssPhotos];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    refreshControl.tintColor = [UIColor magentaColor];
    
    [refreshControl addTarget:self action:@selector(changeSorting) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refreshControl;
}

- (void)changeSorting
{
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"created_at" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    _tssPhotos = [_tssPhotos sortedArrayUsingDescriptors:sortDescriptors];
    
    _ascending = !_ascending;
    
    [self performSelector:@selector(updateTable) withObject:nil
               afterDelay:1];
}

- (void)updateTable
{
    //[_manager fetchTssPhotos];
    
    [self.tableView reloadData];
    
    [self.refreshControl endRefreshing];
}

- (void)didReceiveTssPhotos:(NSArray *)tssPhotos
{
    _tssPhotos = tssPhotos;
    [self.feedsTableView reloadData];
}

- (void) fetchingTssPhotosFailedWithError:(NSError *)error {
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
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
    return _tssPhotos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TssPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SnapIdentifier" forIndexPath:indexPath];
    
    TssPhoto *photo = _tssPhotos[indexPath.row];
    
    NSString *imageURL = [photo photo];

    [cell.tssPhoto setImageWithURL:[NSURL URLWithString:imageURL]];
    
    [cell.tssPhotoLable setText:[NSString stringWithFormat:@"Posted by %@ at %@", [photo user_id], [photo created_at]]];
    
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
