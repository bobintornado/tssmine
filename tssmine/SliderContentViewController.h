//
//  SliderContentViewController.h
//  tssmine
//
//  Created by Bob Cao on 18/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderContentViewController : UIViewController

@property (strong, nonatomic) IBOutlet PFImageView *sliderView;
@property (strong, nonatomic) PFObject *sliderObject;

@property NSUInteger pageIndex;

@end
