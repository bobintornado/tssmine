//
//  StlyingViewController.m
//  tssmine
//
//  Created by Bob Cao on 14/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "StlyingViewController.h"

@interface StlyingViewController ()

@end

@implementation StlyingViewController

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
- (IBAction)didTapOnStylingQuiz:(id)sender {
     [self performSegueWithIdentifier: @"stylingQuiz" sender: self];
}
- (IBAction)didTapOnSavedStlyes:(id)sender {
     [self performSegueWithIdentifier: @"customize" sender: self];
}
- (IBAction)didTapOnQuizImage:(id)sender {
    [self performSegueWithIdentifier: @"stylingQuiz" sender: self];
}


@end
