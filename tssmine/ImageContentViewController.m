//
//  ImageContentViewController.m
//  mySMUShop
//
//  Created by Bob Cao on 14/4/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "ImageContentViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface ImageContentViewController ()

@end

@implementation ImageContentViewController

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
    UIImageView *dot =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,320)];
    [dot setBackgroundColor:[UIColor whiteColor]];
    [dot setImageWithURL:[NSURL URLWithString:self.imageURLStr] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:dot];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self.pIV setImageWithURL:[NSURL URLWithString:self.imageURLStr] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.pIV setBackgroundColor:[UIColor blueColor]];
    
    [self.view setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
