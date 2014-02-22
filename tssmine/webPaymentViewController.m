
//
//  webPaymentViewController.m
//  mySMU
//
//  Created by Bob Cao on 23/2/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "webPaymentViewController.h"

@interface webPaymentViewController ()
@property (strong, nonatomic) IBOutlet UINavigationItem *webNav;
@property (strong, nonatomic) IBOutlet UIWebView *viewWeb;

@end

@implementation webPaymentViewController

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
    
    _webNav.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:(@selector(cancelPurchase))];
    
    NSURL *url = [NSURL URLWithString:_fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_viewWeb loadRequest:requestObj];
}

- (void)cancelPurchase {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
