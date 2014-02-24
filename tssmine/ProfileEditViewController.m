//
//  ProfileEditViewController.m
//  mySMU
//
//  Created by Bob Cao on 25/2/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "ProfileEditViewController.h"

@interface ProfileEditViewController ()

@property (strong, nonatomic) IBOutlet UITextField *editField;

@end

@implementation ProfileEditViewController

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
    UIColor *color = [UIColor grayColor];
    switch (self.editMood)
    {
        case 0:
            self.title = @"Display Name";
            if ([[PFUser currentUser] objectForKey:@"displayName"]!= NULL){
                self.editField.text = [[PFUser currentUser] objectForKey:@"displayName"];
                self.editField.textColor = [UIColor blackColor];
            } else {
                self.editField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Display Name" attributes:@{NSForegroundColorAttributeName: color}];
            }
            break;
        case 1:
            self.title = @"Phone Number";
            if ([[PFUser currentUser] objectForKey:@"phoneNumber"]!= NULL){
                self.editField.text = [[PFUser currentUser] objectForKey:@"phoneNumber"];
                self.editField.textColor = [UIColor blackColor];
            } else {
                self.editField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Phone Number" attributes:@{NSForegroundColorAttributeName: color}];
            }
            break;
        case 2:
            self.title = @"Email";
            if ([[PFUser currentUser] objectForKey:@"email"]!= NULL){
                self.editField.text = [[PFUser currentUser] objectForKey:@"email"];
                self.editField.textColor = [UIColor blackColor];
            } else {
                self.editField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
            }
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateProfile:(id)sender {
    switch (self.editMood)
    {
        case 0:
            [[PFUser currentUser] setObject:self.editField.text forKey:@"displayName"];
            [[PFUser currentUser] saveInBackground];
            break;
        case 1:
            [[PFUser currentUser] setObject:self.editField.text forKey:@"phoneNumber"];
            [[PFUser currentUser] saveInBackground];
            break;
        case 2:
            [[PFUser currentUser] setObject:self.editField.text forKey:@"email"];
            [[PFUser currentUser] saveInBackground];
            break;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
