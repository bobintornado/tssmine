//
//  BorGViewController.m
//  tssmine
//
//  Created by Bob Cao on 16/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "BorGViewController.h"
#import "QuizCenter.h"

@interface BorGViewController ()

@end

@implementation BorGViewController

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

- (IBAction)choseBoy:(id)sender {
    QuizCenter *sharedCenter = [QuizCenter sharedCenter];
    NSRange range = NSMakeRange(0,1);
    sharedCenter.result = [sharedCenter.result stringByReplacingCharactersInRange:range withString:@"A"];
}
- (IBAction)choseGirl:(id)sender {
    QuizCenter *sharedCenter = [QuizCenter sharedCenter];
    NSRange range = NSMakeRange(0,1);
    sharedCenter.result = [sharedCenter.result stringByReplacingCharactersInRange:range withString:@"B"];
}

@end
