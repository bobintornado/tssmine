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
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self.sliderImageView setImageWithURL:self.slider.image];
    
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:self.slider.image options:0 progress:^(NSUInteger receivedSize, long long expectedSize)
     {
         // progression tracking code
     } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
         if (image && finished)
         {
             self.image = image;
             [self.sliderImageView setImage:self.image];
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
