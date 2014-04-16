//
//  ProfileViewController.m
//  tssmine
//
//  Created by Bob Cao on 14/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "ProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ProfileCell.h"
#import "ProfileEditViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "TssLoginViewController.h"
#import "MySMUViewController.h"
#import "RootTabBarViewController.h"

@interface ProfileViewController ()

@property (strong, nonatomic) IBOutlet UITableView *profileTableView;
@property (nonatomic, strong) PFFile *photoFile;
@property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property (nonatomic, assign) UIBackgroundTaskIdentifier photoPostBackgroundTaskId;
@property (strong, nonatomic) IBOutlet PFImageView *profileImg;

@end

@implementation ProfileViewController

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
    NSLog(@"profile");
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view.
    if ([[PFUser currentUser] objectForKey:@"profileImg"] !=NULL) {
        self.profileImg.file = [[PFUser currentUser] objectForKey:@"profileImg"];
        [self.profileImg loadInBackground];
    }
    self.profileImg.layer.cornerRadius = 100;
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    if (![PFUser currentUser]) {
//        // Create the log in view controller
//        
//        TssLoginViewController *logInViewController = [[TssLoginViewController alloc] init];
//        [logInViewController setDelegate:(RootTabBarViewController *)self.tabBarController];
//        //[logInViewController setFields: PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton| PFLogInFieldsPasswordForgotten];
//        
//        // Create the sign up view controller
//        MySMUViewController *signUpViewController = [[MySMUViewController alloc] init];
//        [signUpViewController setFields:PFSignUpFieldsDefault | PFSignUpFieldsAdditional];
//        [signUpViewController setDelegate:(RootTabBarViewController *)self.tabBarController];
//        // Assign our sign up controller to be displayed from the login controller
//        [logInViewController setSignUpController:signUpViewController];
//        
//        // Present the log in view controller
//        self.navigationController.viewControllers = [NSArray arrayWithObject: logInViewController];
//        //[self.navigationController popViewControllerAnimated:NO];
//        //[self presentViewController:logInViewController animated:YES completion:nil];
//        //[self.navigationController pushViewController:logInViewController animated:YES];
//        //[self.tabBarController presentViewController:logInViewController animated:YES completion:NULL];
//        //[self.tabBarController.moreNavigationController popToRootViewControllerAnimated:NO];
//        //protection code for what is the frist tab bar goes here
//        //[self.tabBarController setSelectedIndex:0];
//    }
//}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.profileTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didTapOnLogOut:(id)sender {
    [PFUser logOut];
    NSMutableArray* newArray = [NSMutableArray arrayWithArray:self.tabBarController.viewControllers];
    for (UIViewController *vc in newArray) {
        if ([[vc restorationIdentifier] isEqualToString:@"profileNav"]) {
            [newArray removeObject:vc];
            UINavigationController *p = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
            [newArray addObject:p];
        }
    }
    [self.tabBarController setViewControllers:newArray animated:YES];
    [self.tabBarController setSelectedIndex:0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //mark cell indentifier in storyboard
    static NSString *CellIdentifier = @"profileCell";
    
    //assign indentifer
    ProfileCell *cell = (ProfileCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //initilize with identifer
    if (cell == nil) {
        cell = [[ProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.row)
    {
        case 0:
            cell.head.text = @"Display Name";
            if ([[PFUser currentUser] objectForKey:@"displayName"]!= NULL){
                cell.content.text = [[PFUser currentUser] objectForKey:@"displayName"];
                cell.content.textColor = [UIColor blackColor];
            } else {
                cell.content.text = @"Not Set";
                cell.content.textColor = [UIColor grayColor];
            }
            break;
        case 1:
            cell.head.text = @"Phone Number";
            if ([[PFUser currentUser] objectForKey:@"phoneNumber"] !=NULL){
                cell.content.text = [[PFUser currentUser] objectForKey:@"phoneNumber"];
                cell.content.textColor = [UIColor blackColor];
            } else {
                cell.content.text = @"Not Set";
                cell.content.textColor = [UIColor grayColor];
            }
            break;
        case 2:
            cell.head.text = @"Email";
            cell.content.adjustsFontSizeToFitWidth=YES;
            if ([[PFUser currentUser] objectForKey:@"email"] !=NULL){
                cell.content.text = [[PFUser currentUser] objectForKey:@"email"];
                cell.content.textColor = [UIColor blackColor];
            } else {
                cell.content.text = @"Not Set";
                cell.content.textColor = [UIColor grayColor];
            }
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ProfileEditViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"profileEditing"];
    
    vc.editMood = indexPath.row;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didTapProfilePicture:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Snap A Profile", @"Choose From Library",nil];
    [actionSheet showInView:self.view];
}
//action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        if (buttonIndex == 0) {
            
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.showsCameraControls = YES;
            
            [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
            
        } else if (buttonIndex == 1) {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
        }
        [imagePicker setDelegate:self];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //dismiss
    [self dismissViewControllerAnimated:NO completion:nil];
    
    //processing
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8f);
    self.photoFile = [PFFile fileWithData:imageData];
    self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
    }];
    [self.photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Photo uploaded successfully");
        } else {
            [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
        }
    }];
    [[PFUser currentUser] setObject:self.photoFile forKey:@"profileImg"];
    self.photoPostBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
    }];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Photo uploaded");
            self.profileImg.file = [[PFUser currentUser] objectForKey:@"profileImg"];
            [self.profileImg loadInBackground];
        } else {
            NSLog(@"Photo failed to save: %@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
            [alert show];
        }
        [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
    }];
}


@end
