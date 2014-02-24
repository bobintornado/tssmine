//
//  ProfileViewController.m
//  tssmine
//
//  Created by Bob Cao on 14/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "ProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ProfileCell.h"
#import "ProfileEditViewController.h"

@interface ProfileViewController ()

@property (strong, nonatomic) IBOutlet UITableView *profileTableView;

@end

@implementation ProfileViewController

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
    NSLog(@"profile");
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.profileTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didTapOnLogOut:(id)sender {
    [PFUser logOut];
    [self.tabBarController viewDidAppear:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //mark cell indentifier in storyboard
    static NSString *CellIdentifier = @"profileCell";
    
    //assign indentifer
    ProfileCell *cell = (ProfileCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //initilize with identifer
    if (cell == nil) {
        cell = [[ProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.row)
    {
        case 0:
            cell.head.text = @"Display Name";
            if ([[PFUser currentUser] objectForKey:@"displayName"]!= NULL){
                cell.content.text = [[PFUser currentUser] objectForKey:@"displayName"];
                cell.content.textColor = [UIColor blackColor];
            } else {
                cell.content.text = @"Not Set";
                cell.content.textColor = [UIColor grayColor];
            }
            break;
        case 1:
            cell.head.text = @"Phone Number";
            if ([[PFUser currentUser] objectForKey:@"phoneNumber"] !=NULL){
                cell.content.text = [[PFUser currentUser] objectForKey:@"phoneNumber"];
                cell.content.textColor = [UIColor blackColor];
            } else {
                cell.content.text = @"Not Set";
                cell.content.textColor = [UIColor grayColor];
            }
            break;
        case 2:
            cell.head.text = @"Email";
            cell.content.adjustsFontSizeToFitWidth=YES;
            if ([[PFUser currentUser] objectForKey:@"email"] !=NULL){
                cell.content.text = [[PFUser currentUser] objectForKey:@"email"];
                cell.content.textColor = [UIColor blackColor];
            } else {
                cell.content.text = @"Not Set";
                cell.content.textColor = [UIColor grayColor];
            }
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ProfileEditViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"profileEditing"];
    
    vc.editMood = indexPath.row;
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end
