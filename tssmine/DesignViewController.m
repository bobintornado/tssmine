//
//  DesignViewController.m
//  tssmine
//
//  Created by Bob Cao on 2/11/13.
//  Copyright (c) 2013 Bob Cao. All rights reserved.
//

#import "DesignViewController.h"

@interface DesignViewController () 

@end

@implementation DesignViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)swipe:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"abc" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:@"yes go ahead" otherButtonTitles:@"kill him",nil];
    [sheet showInView:self.view];
}
- (IBAction)longpress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        //Do Whatever You want on End of Gesture
    }
    else if (sender.state == UIGestureRecognizerStateBegan){
        NSLog(@"UIGestureRecognizerStateBegan.");
        //Do Whatever You want on Began of Gesture
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"abc" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:@"yes go ahead" otherButtonTitles:@"kill him",nil];
        [sheet showInView:self.view];
        
    }

}
@end
