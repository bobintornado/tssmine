//
//  ShopSliderViewController.h
//  mySMU
//
//  Created by Bob Cao on 1/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSSSlider.h"

@interface ShopSliderViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *sliderImageView;
@property (strong, nonatomic) TSSSlider *slider;
@property (strong, nonatomic) UIImage *image;

@end
