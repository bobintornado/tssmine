//
//  GirlSMUViewController.m
//  tssmine
//
//  Created by Bob Cao on 27/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "GirlSMUViewController.h"
#import "QuizCenter.h"

@interface GirlSMUViewController ()

@end

@implementation GirlSMUViewController

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
- (IBAction)choseSMU:(id)sender {
    QuizCenter *sharedCenter = [QuizCenter sharedCenter];
    NSRange range = NSMakeRange(3,1);
    sharedCenter.result = [sharedCenter.result stringByReplacingCharactersInRange:range withString:@"A"];
    NSLog(sharedCenter.result);
    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"popBack" object:nil]];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)choseNonSMU:(id)sender {
    QuizCenter *sharedCenter = [QuizCenter sharedCenter];
    NSRange range = NSMakeRange(3,1);
    sharedCenter.result = [sharedCenter.result stringByReplacingCharactersInRange:range withString:@"B"];
    NSLog(sharedCenter.result);
    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"popBack" object:nil]];
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}

@end
