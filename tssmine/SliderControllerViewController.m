//
//  SliderControllerViewController.m
//  tssmine
//
//  Created by Bob Cao on 18/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "SliderControllerViewController.h"
#import "SliderContentViewController.h"

@interface SliderControllerViewController ()

@end

@implementation SliderControllerViewController

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
    self.contentViewControllers = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Slider"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error){
            self.dataSource = self;
            self.sliderObjects = objects;
            NSLog(@"successfully retrieve all sliders");
            for (PFObject *object in objects) {
                SliderContentViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"sliderContent"];
                PFFile *file = [object objectForKey:@"banner"];
                NSData *data = [file getData];
                vc.imageFile = [UIImage imageWithData:data];
                vc.pageIndex = [objects indexOfObject:object];
                [self.contentViewControllers addObject:vc];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        };
        [self setViewControllers:@[[self.contentViewControllers objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(SliderContentViewController *)viewController {
    
    NSUInteger index = viewController.pageIndex;
    
    if (index == 0) {
        return nil;
    }
    
    index--;

    return [self.contentViewControllers objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(SliderContentViewController *)viewController {
    
    NSUInteger index = viewController.pageIndex;
    
    
    index++;
    
    if (index == [self.sliderObjects count]) {
        return nil;
    }
    
    return [self.contentViewControllers objectAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.contentViewControllers count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
