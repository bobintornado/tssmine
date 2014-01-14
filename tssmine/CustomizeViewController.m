//
//  CustomizeViewController.m
//  tssmine
//
//  Created by Bob Cao on 14/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "CustomizeViewController.h"

@interface CustomizeViewController ()

@end

@implementation CustomizeViewController

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
    PFQuery *upperQuery = [PFQuery queryWithClassName:@"Upper"];
    [upperQuery getObjectInBackgroundWithId:@"jcezeEkp7K" block:^(PFObject *upperImageFile, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
        NSLog(@"%@", upperImageFile);
        self.upperImage.file = [upperImageFile objectForKey:@"image"];
        [self.upperImage loadInBackground];
    }];
    
    PFQuery *underQuery = [PFQuery queryWithClassName:@"Under"];
    [underQuery getObjectInBackgroundWithId:@"jcezeEkp7K" block:^(PFObject *upperImageFile, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
        NSLog(@"%@", upperImageFile);
        self.downImage.file = [upperImageFile objectForKey:@"image"];
        [self.downImage loadInBackground];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
