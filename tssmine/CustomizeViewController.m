//
//  CustomizeViewController.m
//  tssmine
//
//  Created by Bob Cao on 16/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "CustomizeViewController.h"

@interface CustomizeViewController ()

@property (strong, nonatomic) IBOutlet UINavigationBar *customizeNavBar;
@property (strong, nonatomic) IBOutlet PFImageView *upper;
@property (strong, nonatomic) IBOutlet PFImageView *under;
@property (strong, nonatomic) IBOutlet PFImageView *accessory;

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
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = @"Customize";
    //adding right button for photo taking
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelCustomize)];
    navItem.leftBarButtonItem = leftButton;

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareOutFit)];
    navItem.rightBarButtonItem =rightButton;
    
    //adding all items to navigation bar
    self.customizeNavBar.items = @[ navItem ];
    
    //self.upper =
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shareOutFit{
    //futher customization is needed
    NSString *shareString = @"My style!";
    
    //Get the image needed to shared before user clicks on sharing
    //PFFile *imageFile = [self.snapObject objectForKey:@"snapPicture"];
    //NSData *data = [imageFile getData];
    //UIImage *shareImage = [UIImage imageWithData:data];
    
    //config the sharing
    NSArray *activityItems = [NSArray arrayWithObjects:shareString, nil];
    
    //present the sharing window
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:activityViewController animated:YES completion:nil];
}

-(void)cancelCustomize{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
