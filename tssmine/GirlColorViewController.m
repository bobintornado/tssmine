//
//  GirlColorViewController.m
//  tssmine
//
//  Created by Bob Cao on 27/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "GirlColorViewController.h"
#import "QuizCenter.h"

@interface GirlColorViewController ()

@end

@implementation GirlColorViewController

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
- (IBAction)choseBright:(id)sender {
    QuizCenter *sharedCenter = [QuizCenter sharedCenter];
    NSRange range = NSMakeRange(1,1);
    sharedCenter.result = [sharedCenter.result stringByReplacingCharactersInRange:range withString:@"A"];
    NSLog(sharedCenter.result);
    [self performSegueWithIdentifier:@"GirlQuiz3" sender:sender];
}
- (IBAction)choseDark:(id)sender {
    QuizCenter *sharedCenter = [QuizCenter sharedCenter];
    NSRange range = NSMakeRange(1,1);
    sharedCenter.result = [sharedCenter.result stringByReplacingCharactersInRange:range withString:@"B"];
    NSLog(sharedCenter.result);
    [self performSegueWithIdentifier:@"GirlQuiz3" sender:sender];
}

@end
