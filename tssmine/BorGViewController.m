//
//  BorGViewController.m
//  tssmine
//
//  Created by Bob Cao on 16/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "BorGViewController.h"

@interface BorGViewController ()

@end

@implementation BorGViewController

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
- (IBAction)didTapOnBoy:(id)sender {
    [self performSegueWithIdentifier:@"imboy" sender:sender];
}
- (IBAction)didTapOnGirl:(id)sender {
    [self performSegueWithIdentifier:@"imgirl" sender:sender];
}

@end
