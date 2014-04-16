//
//  RootTabBarViewController.m
//  tssmine
//
//  Created by Bob Cao on 16/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "RootTabBarViewController.h"
#import "TssLoginViewController.h"
#import "MySMUViewController.h"
#import "AppDelegate.h"

@interface RootTabBarViewController ()

@end

@implementation RootTabBarViewController

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
    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([PFUser currentUser]) {
        NSMutableArray* newArray = [NSMutableArray arrayWithArray:self.viewControllers];
        for (UIViewController *vc in newArray) {
            if ([[vc restorationIdentifier] isEqualToString:@"loginnv"]) {
                [newArray removeObject:vc];
                UINavigationController *p = [self.storyboard instantiateViewControllerWithIdentifier:@"profileNav"];
                [newArray addObject:p];
            }
        }
        [self setViewControllers:newArray animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
    NSMutableArray* newArray = [NSMutableArray arrayWithArray:self.viewControllers];
    
    for (UIViewController *vc in newArray) {
        if ([[vc restorationIdentifier] isEqualToString:@"loginVC"]) {
            [newArray removeObject:vc];
            UINavigationController *p = [self.storyboard instantiateViewControllerWithIdentifier:@"profileNav"];
            [newArray addObject:p];
        }
    }
    
    [self setViewControllers:newArray animated:YES];
    
    for (UIViewController *vc in newArray) {
        if ([[vc restorationIdentifier] isEqualToString:@"profileNav"]) {
            [self setSelectedViewController:vc];
        }
    }
}

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil]; // Dismiss the PFSignUpViewController
    NSMutableArray* newArray = [NSMutableArray arrayWithArray:self.viewControllers];
    
    for (UIViewController *vc in newArray) {
        if ([[vc restorationIdentifier] isEqualToString:@"loginVC"]) {
            [newArray removeObject:vc];
            UINavigationController *p = [self.storyboard instantiateViewControllerWithIdentifier:@"profileNav"];
            [newArray addObject:p];
        }
    }
    
    [self setViewControllers:newArray animated:YES];
    
    for (UIViewController *vc in newArray) {
        if ([[vc restorationIdentifier] isEqualToString:@"profileNav"]) {
            [self setSelectedViewController:vc];
        }
    }
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

@end
