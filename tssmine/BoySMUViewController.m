//
//  BoySMUViewController.m
//  tssmine
//
//  Created by Bob Cao on 27/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "BoySMUViewController.h"

@interface BoySMUViewController ()

@end

@implementation BoySMUViewController

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
- (IBAction)choseSMU:(id)sender {
    [self performSegueWithIdentifier:@"BoyResult" sender:sender];
}
- (IBAction)choseNonSMU:(id)sender {
    [self performSegueWithIdentifier:@"BoyResult" sender:sender];
}

@end
