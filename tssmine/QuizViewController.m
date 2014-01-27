//
//  QuizViewController.m
//  TheSMUShop
//
//  Created by Bob Cao on 27/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "QuizViewController.h"
#import "CustomizeCell.h"
#import "QuizCenter.h"

@interface QuizViewController ()

@end

@implementation QuizViewController

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
        PFQuery *query = [PFQuery queryWithClassName:@"Combo"];
        [query includeKey:@"Upper"];
        [query includeKey:@"Under"];
        [query includeKey:@"Bottom"];
        QuizCenter *shareCenter = [QuizCenter sharedCenter];
        [query whereKey:@"Answers" equalTo:shareCenter.result];
        PFObject *combo = [[query findObjects] firstObject];
        
        //Products
        PFObject *upperProduct = [combo objectForKey:@"Upper"];
        PFObject *underProduct = [combo objectForKey:@"Under"];
        PFObject *bottomProduct = [combo objectForKey:@"Bottom"];
        
        //Files
        self.upper = [upperProduct objectForKey:@"PreviewImage"];
        self.under = [underProduct objectForKey:@"PreviewImage"];
        self.bottom = [bottomProduct objectForKey:@"PreviewImage"];
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
