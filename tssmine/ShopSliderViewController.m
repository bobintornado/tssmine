//
//  ShopSliderViewController.m
//  mySMU
//
//  Created by Bob Cao on 1/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "ShopSliderViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ShopSliderViewController ()

@end

@implementation ShopSliderViewController

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
    //[self.sliderImageView setImage:[UIImage imageNamed:@"banner1.png"]];
    [self reloadInputViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
