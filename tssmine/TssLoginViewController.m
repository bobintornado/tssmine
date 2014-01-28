//
//  TssLoginViewController.m
//  tssmine
//
//  Created by Bob Cao on 16/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "TssLoginViewController.h"

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
    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"woodentexture.png"]]];
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TSS-WoodenLogo.png"]]];
    [self.logInView.usernameField setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"darkwoodtexture.png"]]];
    [self.logInView.passwordField setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"darkwoodtexture.png"]]];
    
    
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"darkwoodtexture.png"] forState:UIControlStateNormal];
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"darkwoodtexture.png"] forState:UIControlStateHighlighted];
    [self.logInView.signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitle:@"Sign Up" forState:UIControlStateHighlighted];
    
    // Set field text color
    [self.logInView.usernameField setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]];
    [self.logInView.passwordField setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
