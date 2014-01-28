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
    NSLog(@"styling");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushViews) name:@"popBack" object:nil];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViews {
    //Pop back to the root view controller
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self performSegueWithIdentifier: @"quizResult" sender: self];
}

- (IBAction)createStyle:(id)sender {
    [self performSegueWithIdentifier:@"createStyle" sender:self];
}

- (IBAction)takeQuiz:(id)sender {
    [self performSegueWithIdentifier:@"stylingQuiz" sender:self];
}


@end
