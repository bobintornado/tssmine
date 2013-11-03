//
//  ProfileViewController.h
//  tssmine
//
//  Created by Bob Cao on 2/11/13.
//  Copyright (c) 2013 Bob Cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *emailText;
@property (strong, nonatomic) IBOutlet UITextField *passwordText;
- (IBAction)loginClicked:(id)sender;
- (IBAction)backgroundClicked:(id)sender;

@end
