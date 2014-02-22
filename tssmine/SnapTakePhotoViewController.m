//
//  SnapTakePhotoViewController.m
//  tssmine
//
//  Created by Bob Cao on 6/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "SnapTakePhotoViewController.h"

@interface SnapTakePhotoViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) PFFile *photoFile;
@property (nonatomic, strong) PFFile *thumbnailFile;
@property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property (nonatomic, assign) UIBackgroundTaskIdentifier photoPostBackgroundTaskId;
@property (strong, nonatomic) IBOutlet UITextField *snapTitle;

@end

@implementation SnapTakePhotoViewController

//depreciated init method due to init with storyboard identifier
- (id)initWithImage:(UIImage *)aImage{
    self = [super initWithNibName:nil bundle:nil];
    //passing the image
    if (self) {
        if (!aImage) {
            return nil;
        }
        self.image = aImage;
        self.fileUploadBackgroundTaskId = UIBackgroundTaskInvalid;
        self.photoPostBackgroundTaskId = UIBackgroundTaskInvalid;
    }
    return self;
}

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
	// Display the image
    [self.imageView setImage:_image];
    //adding Title
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = @"New Snap";
    //adding right button for photo taking
    UIBarButtonItem *leftCancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPost:)];
    
    UIBarButtonItem *rightPublishButton = [[UIBarButtonItem alloc] initWithTitle:@"Publish" style:UIBarButtonItemStyleDone target:self action:@selector(publishNewSnap)];
    
    navItem.leftBarButtonItem = leftCancelButton;
    navItem.rightBarButtonItem = rightPublishButton;
    //adding all items to navigation bar
    _postSnapNavBar.items = @[ navItem ];
    
    //prepare to uploading the photo
    [self shouldUploadImage:self.image];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSnapImage:(UIImage *)aImage{
    //passing the image
    if (self) {
        //seting image without checking its existence
        //keep this way for now and may fix later
        self.image = aImage;
        self.fileUploadBackgroundTaskId = UIBackgroundTaskInvalid;
        self.photoPostBackgroundTaskId = UIBackgroundTaskInvalid;
    }
}

- (void)cancelPost:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldUploadImage:(UIImage *)anImage{
    
    //will uncomment this two parts out to really generate two files
    //UIImage *resizedImage = [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(560.0f, 560.0f) interpolationQuality:kCGInterpolationHigh];
    //UIImage *thumbnailImage = [anImage thumbnailImage:86.0f transparentBorder:0.0f cornerRadius:10.0f interpolationQuality:kCGInterpolationDefault];
    
    // JPEG to decrease file size and enable faster uploads & downloads
    NSData *imageData = UIImageJPEGRepresentation(anImage, 0.8f);
    NSData *thumbnailImageData = UIImagePNGRepresentation(anImage);
    
    if (!imageData || !thumbnailImageData) {
        return NO;
    }
    
    self.photoFile = [PFFile fileWithData:imageData];
    self.thumbnailFile = [PFFile fileWithData:thumbnailImageData];
    
    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
    }];
    
    NSLog(@"Requested background expiration task with id %lu for Anypic photo upload", (unsigned long)self.fileUploadBackgroundTaskId);
    [self.photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Photo uploaded successfully");
            [self.thumbnailFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Thumbnail uploaded successfully");
                }
                [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
            }];
        } else {
            [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
        }
    }];
    
    return YES;
}

- (void)publishNewSnap {
    //NSDictionary *userInfo = [NSDictionary dictionary];
    
    if (!self.photoFile || !self.thumbnailFile) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
        [alert show];
        return;
    }
    
    // both files have finished uploading
    
    //create a photo object
    PFObject *photo = [PFObject objectWithClassName:@"snap"];
    [photo setObject:[PFUser currentUser] forKey:@"poster"];
    [photo setObject:self.photoFile forKey:@"snapPicture"];
    [photo setObject:self.thumbnailFile forKey:@"snapThumbnail"];
    [photo setObject:self.snapTitle.text forKey:@"snapTitle"];
    
    
    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.photoPostBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
    }];
    // save
    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Photo uploaded");
            
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
