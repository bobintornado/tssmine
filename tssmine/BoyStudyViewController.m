//
//  BoyStudyViewController.m
//  tssmine
//
//  Created by Bob Cao on 16/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "BoyStudyViewController.h"
#import "QuizCenter.h"

@interface BoyStudyViewController ()

@end

@implementation BoyStudyViewController

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
- (IBAction)choseStudy:(id)sender {
    QuizCenter *sharedCenter = [QuizCenter sharedCenter];
    NSRange range = NSMakeRange(2,1);
    sharedCenter.result = [sharedCenter.result stringByReplacingCharactersInRange:range withString:@"A"];
    [self performSegueWithIdentifier:@"BoyQuiz4" sender:sender];
}

- (IBAction)choseGYM:(id)sender {
    QuizCenter *sharedCenter = [QuizCenter sharedCenter];
    NSRange range = NSMakeRange(2,1);
    sharedCenter.result = [sharedCenter.result stringByReplacingCharactersInRange:range withString:@"B"];
    [self performSegueWithIdentifier:@"BoyQuiz4" sender:sender];
}

@end
