//
//  SliderContentViewController.m
//  tssmine
//
//  Created by Bob Cao on 18/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "SliderContentViewController.h"

@interface SliderContentViewController ()

@end

@implementation SliderContentViewController

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
	// Load the view when user swipes. Pre-caching is a good idea but not implemented yet
    self.sliderView.file = [self.sliderObject objectForKey:@"banner"];
    [self.sliderView loadInBackground];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
