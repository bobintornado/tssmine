//
//  BoySMUViewController.m
//  tssmine
//
//  Created by Bob Cao on 27/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "BoySMUViewController.h"
#import "QuizCenter.h"

@interface BoySMUViewController ()

@end

@implementation BoySMUViewController

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
- (IBAction)choseSMULogo:(id)sender {
    QuizCenter *sharedCenter = [QuizCenter sharedCenter];
    NSRange range = NSMakeRange(3,1);
    sharedCenter.result = [sharedCenter.result stringByReplacingCharactersInRange:range withString:@"A"];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"popBack" object:nil]];
    
    [self.navigationController popToRootViewControllerAnimated:NO];}

- (IBAction)choseNoSMULogo:(id)sender {
    QuizCenter *sharedCenter = [QuizCenter sharedCenter];
    NSRange range = NSMakeRange(3,1);
    sharedCenter.result = [sharedCenter.result stringByReplacingCharactersInRange:range withString:@"B"];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"popBack" object:nil]];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
