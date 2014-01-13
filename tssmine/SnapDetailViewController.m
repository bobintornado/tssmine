//
//  SnapDetailViewController.m
//  tssmine
//
//  Created by Bob Cao on 6/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "SnapDetailViewController.h"
#import "TSSUtility.h";

@interface SnapDetailViewController ()

@end

@implementation SnapDetailViewController

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
    
    //configure the navigation bar
    self.navigationItem.title = @"Snap Detail";
    
    //set right button as the sharing action button
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareSnap)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.snapPFImageView.file = [self.snapObject objectForKey:@"snapPicture"];
    [self.snapPFImageView loadInBackground];
    
    PFQuery *snapLikeCount = [[PFQuery alloc] initWithClassName:@"ActivityLike"];
    [snapLikeCount whereKey:@"snapPhoto" equalTo:self.snapObject];
    [snapLikeCount countObjectsInBackgroundWithBlock:^(int number, NSError *error){
        self.detailStatLab.text = [NSString stringWithFormat:@"%d likes 0 comments", number];
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shareSnap{
    //futher customization is needed
    NSString *shareString = @"CapTech is a great place to work.";
    UIImage *shareImage = [UIImage imageNamed:@"captech-logo.jpg"];
    NSURL *shareUrl = [NSURL URLWithString:@"http://www.captechconsulting.com"];
    
    NSArray *activityItems = [NSArray arrayWithObjects:shareString, shareImage, shareUrl, nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)setUpDetailViewWithObject:(PFObject *)snapObject{
    self.snapObject = snapObject;
}

- (IBAction)didTapLikeButton:(id)sender {
    [TSSUtility likePhotoInBackground:self.snapObject block:nil];
}

@end
