//
//  TssLoginViewController.m
//  tssmine
//
//  Created by Bob Cao on 16/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "TssLoginViewController.h"
#import "RootTabBarViewController.h"

@interface TssLoginViewController ()

@end

@implementation TssLoginViewController

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
    //[self.logInView setBackgroundColor:[UIColor whiteColor]];
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]]];
    
    [self.logInView.signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitle:@"Sign Up" forState:UIControlStateHighlighted];
    
    // Set field text color
    [self.logInView.usernameField setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]];
    [self.logInView.passwordField setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]];
    
    self.delegate = (RootTabBarViewController *)self.tabBarController;
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
    NSMutableArray* newArray = [NSMutableArray arrayWithArray:self.tabBarController.viewControllers];
    NSLog(@"%d", [newArray count]);
    
    for (UIViewController *vc in newArray) {
        if ([[vc restorationIdentifier] isEqualToString:@"loginnv"]) {
            [newArray removeObject:vc];
        }
    }
    
    NSLog(@"called");
    [newArray removeObject: logInController.navigationController];
    NSLog(@"%d", [newArray count]);
    [self.tabBarController setViewControllers:newArray animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
