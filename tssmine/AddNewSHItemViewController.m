//
//  AddNewSHItemViewController.m
//  mySMU
//
//  Created by Bob Cao on 21/2/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "AddNewSHItemViewController.h"

@interface AddNewSHItemViewController ()

@property (strong, nonatomic) IBOutlet UITextView *itemDes;
@property (strong, nonatomic) IBOutlet UITextField *itemPrice;
@property (strong, nonatomic) IBOutlet UITextField *category;
@property (strong, nonatomic) IBOutlet UITextField *itemTitle;
@property (strong, nonatomic) IBOutlet UIImageView *itemPhotoView;
@property (strong, nonatomic) IBOutlet UINavigationBar *nav;
@property PFFile *photoFile;

@property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property (nonatomic, assign) UIBackgroundTaskIdentifier photoPostBackgroundTaskId;

@end

@implementation AddNewSHItemViewController

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
    self.itemDes.delegate = self;
    self.itemDes.text = @"placeholder text here...";
    self.itemDes.textColor = [UIColor lightGrayColor];
    
    [self.itemPhotoView setImage:self.itemPhoto];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = @"New Item";

    UIBarButtonItem *leftCancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPost)];
    
    UIBarButtonItem *rightPublishButton = [[UIBarButtonItem alloc] initWithTitle:@"Publish" style:UIBarButtonItemStyleDone target:self action:@selector(publishNewItem)];
    
    navItem.leftBarButtonItem = leftCancelButton;
    navItem.rightBarButtonItem = rightPublishButton;
    self.nav.items = @[navItem];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [self shouldUploadItem:self.itemPhoto];
}

- (BOOL)shouldUploadItem:(UIImage *)anImage{
    
    //will uncomment this two parts out to really generate two files
    //UIImage *resizedImage = [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(560.0f, 560.0f) interpolationQuality:kCGInterpolationHigh];
    //UIImage *thumbnailImage = [anImage thumbnailImage:86.0f transparentBorder:0.0f cornerRadius:10.0f interpolationQuality:kCGInterpolationDefault];
    
    // JPEG to decrease file size and enable faster uploads & downloads
    NSData *imageData = UIImageJPEGRepresentation(anImage, 0.8f);
    //NSData *thumbnailImageData = UIImagePNGRepresentation(anImage);
    
//    if (!imageData || !thumbnailImageData) {
//        return NO;
//    }
    
    self.photoFile = [PFFile fileWithData:imageData];
    
    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
    }];
    
    NSLog(@"Requested background expiration task with id %lu for Anypic photo upload", (unsigned long)self.fileUploadBackgroundTaskId);
    
    [self.photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Photo uploaded successfully");
        } else {
            [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
        }
    }];
    
    return YES;
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)setItemImage:(UIImage *)aImage{
    //passing the image
    if (self) {
        //seting image without checking its existence
        //keep this way for now and may fix later
        self.itemPhoto = aImage;
        self.fileUploadBackgroundTaskId = UIBackgroundTaskInvalid;
        self.photoPostBackgroundTaskId = UIBackgroundTaskInvalid;
    }
}

- (void)cancelPost {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"placeholder text here..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"placeholder text here...";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

- (void)publishNewItem {
    //NSDictionary *userInfo = [NSDictionary dictionary];
    
    if (!self.itemPhoto) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
        [alert show];
        return;
    }
    
    // both files have finished uploading
    
    //create a photo object
    PFObject *item = [PFObject objectWithClassName:@"SHItem"];
    [item setObject:self.photoFile forKey:@"img"];
    
    [item setObject:self.category.text forKey:@"category"];
    [item setObject:self.itemTitle.text forKey:@"title"];
    [item setObject:[PFUser currentUser] forKey:@"seller"];
    [item setObject:self.itemDes.text forKey:@"description"];
    
    NSNumber *price = [NSNumber numberWithDouble:[self.itemPrice.text doubleValue]];
    [item setObject:price forKey:@"price"];
    
    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.photoPostBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
    }];
    // save
    [item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"item uploaded");
            
            //implement this cache feature later
            //[[PAPCache sharedCache] setAttributesForPhoto:photo likers:[NSArray array] commenters:[NSArray array] likedByCurrentUser:NO];
            
            //commenting out the following (maybe needed later)
            // userInfo might contain any caption which might have been posted by the uploader
            //            if (userInfo) {
            //                NSString *commentText = [userInfo objectForKey:kPAPEditPhotoViewControllerUserInfoCommentKey];
            //
            //                if (commentText && commentText.length != 0) {
            //                    // create and save photo caption
            //                    PFObject *comment = [PFObject objectWithClassName:kPAPActivityClassKey];
            //                    [comment setObject:kPAPActivityTypeComment forKey:kPAPActivityTypeKey];
            //                    [comment setObject:photo forKey:kPAPActivityPhotoKey];
            //                    [comment setObject:[PFUser currentUser] forKey:kPAPActivityFromUserKey];
            //                    [comment setObject:[PFUser currentUser] forKey:kPAPActivityToUserKey];
            //                    [comment setObject:commentText forKey:kPAPActivityContentKey];
            //
            //                    PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            //                    [ACL setPublicReadAccess:YES];
            //                    comment.ACL = ACL;
            //
            //                    [comment saveEventually];
            //                    [[PAPCache sharedCache] incrementCommentCountForPhoto:photo];
            //                }
            //            }
            
            //cancel this notification sending cause i don't really how to deal with this yet
            //[[NSNotificationCenter defaultCenter] postNotificationName:PAPTabBarControllerDidFinishEditingPhotoNotification object:photo];
        } else {
            NSLog(@"Photo failed to save: %@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
            [alert show];
        }
        [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
