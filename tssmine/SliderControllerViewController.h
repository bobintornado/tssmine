//
//  SliderControllerViewController.h
//  tssmine
//
//  Created by Bob Cao on 18/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderControllerViewController : UIPageViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) NSArray *sliderObjects;
@property (strong, nonatomic) NSMutableArray *contentViewControllers;

@end
