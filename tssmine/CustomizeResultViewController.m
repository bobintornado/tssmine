//
//  CustomizeResultViewController.m
//  TheSMUShop
//
//  Created by Bob Cao on 28/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "CustomizeResultViewController.h"
#import "StyleCenter.h"
#import "CustomizeCell.h"

@interface CustomizeResultViewController ()

@property (strong,nonatomic) PFFile *upper;
@property (strong,nonatomic) PFFile *under;
@property (strong,nonatomic) PFFile *bottom;
@property (strong, nonatomic) IBOutlet UITableView *productsTableView;

@end

@implementation CustomizeResultViewController

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
        //Query
        PFQuery *query = [PFQuery queryWithClassName:@"TSSProduct"];
        StyleCenter *shareCenter = [StyleCenter sharedCenter];
        
        //uppper
        [query whereKey:@"objectId" equalTo:shareCenter.upper.objectId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            PFObject *upperProduct =[objects objectAtIndex:0];
            self.upper = [upperProduct objectForKey:@"PreviewImage"];
            [self.productsTableView reloadData];
        }];
        
        
        //under
        query = [PFQuery queryWithClassName:@"TSSProduct"];
        [query whereKey:@"objectId" equalTo:shareCenter.under.objectId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            PFObject *upperProduct =[objects objectAtIndex:0];
            self.under = [upperProduct objectForKey:@"PreviewImage"];
            [self.productsTableView reloadData];
        }];
        
        //bottom
        query = [PFQuery queryWithClassName:@"TSSProduct"];
        [query whereKey:@"objectId" equalTo:shareCenter.bottom.objectId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            PFObject *bottomProduct =[objects objectAtIndex:0];
            self.bottom = [bottomProduct objectForKey:@"PreviewImage"];
            [self.productsTableView reloadData];
        }];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //mark cell indentifier in storyboard
    static NSString *CellIdentifier = @"CustomizeCell";
    
    //Assign indentifer
    CustomizeCell *cell = (CustomizeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //Configure the cell
    if (indexPath.row == 0 ){
        cell.productImage.file = self.upper;
        [cell.productImage loadInBackground];
    } else if (indexPath.row == 1){
        cell.productImage.file = self.under;
        [cell.productImage loadInBackground];
    } else {
        cell.productImage.file = self.bottom;
        [cell.productImage loadInBackground];
    }
    
    //return the cell
    return cell;
}

@end
