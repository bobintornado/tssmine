//
//  BoyColorViewController.m
//  tssmine
//
//  Created by Bob Cao on 27/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "BoyColorViewController.h"

@interface BoyColorViewController ()

@end

@implementation BoyColorViewController

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
- (IBAction)choseBright:(id)sender {
    [self performSegueWithIdentifier:@"boyQuiz2" sender:sender];
}
- (IBAction)choseDark:(id)sender {
    [self performSegueWithIdentifier:@"boyQuiz2" sender:sender];
}

@end
