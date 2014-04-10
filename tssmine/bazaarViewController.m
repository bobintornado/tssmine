//
//  BazaarViewController.m
//  TheSMUShop
//
//  Created by Bob Cao on 20/2/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "BazaarViewController.h"
#import "BazaarPFTableViewCell.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "AddNewSHItemViewController.h"
#import "DesInputTableViewCell.h"
#import <objc/runtime.h>
#import <MessageUI/MessageUI.h>

@interface BazaarViewController ()

@property UIImage *itemPhoto;
@property (strong, nonatomic) IBOutlet UINavigationItem *bazaarUINav;
@property BOOL isFullScreen;
@property CGRect prevFrame;
@property (strong,nonatomic) NSMutableArray *recipients;

@end

@implementation BazaarViewController

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:YES completion:nil];
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
	// Do any additional setup after loading the view
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(publishNewItem) name:@"publishNewItem" object:nil];
    
    PFObject *tracking = [PFObject objectWithClassName:@"tracking"];
    tracking[@"event"] = @"ClickOnTab";
    tracking[@"content"] = @"bazaar";
    tracking[@"device"] = [PFInstallation currentInstallation];
    [tracking saveInBackground];
}

- (void)publishNewItem {
    AddNewSHItemViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"newItem"];
    
    vc.itemPhoto = self.itemPhoto;
    
    [self.navigationController pushViewController:vc animated:YES];
    //[self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)addNewItem:(id)sender {
    if (![PFUser currentUser]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@""
                                                     message:@"Please Login First To Post An Item"
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"OK", nil];
        [av show];
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Snap the Item", @"Choose Existing Photos",nil];
        [actionSheet showInView:self.view];
    }
}

//action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 2) {
        if (buttonIndex == 0) {
            if ([MFMessageComposeViewController canSendText])
                // The device can send email.
            {
                [self displaySMSComposerSheet];
            }
            else
                // The device can not send email.
            {
                NSLog(@"Device not configured to send SMS.");
            }
        }
        if (buttonIndex == 1) {
            NSLog(@"call ownder");
            NSString *phoneNumber = [@"telprompt://" stringByAppendingString:self.recipients[0]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        }
        
    } else {
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
}

- (void)displaySMSComposerSheet
{
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
	picker.messageComposeDelegate = self;
    picker.recipients = self.recipients;
    picker.body = @"I am interested in your xx posted at mySMUShop bazaar, and I would like to ";
	[self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    self.itemPhoto = image;
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"publishNewItem" object:nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // Customize the table
        
        // The className to query on
        self.parseClassName = @"SHItem";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
         NSLog(@"%@", @"42");
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    //mark cell indentifier in storyboard
    static NSString *CellIdentifier = @"bazaarTBV";
    //NSLog(@"%@", @"22");
    
    //assign indentifer
    BazaarPFTableViewCell *cell = (BazaarPFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //initilize with identifer
    if (cell == nil) {
        cell = (BazaarPFTableViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    cell.itemTitle.text = [object objectForKey:@"title"];
    cell.itemImg.file = [object objectForKey:@"img"];
    [cell.itemImg loadInBackground];
    cell.itemDes.text = [object objectForKey:@"description"];
    
    cell.price.text = [NSString stringWithFormat:@"SGD $%@",                                                [[object objectForKey:@"price"] stringValue]];
    
    PFQuery *query = [PFQuery queryWithClassName:@"SHItem"];
    [query includeKey:@"seller"];
    [query includeKey:@"category"];

    [query getObjectInBackgroundWithId:object.objectId block:^(PFObject *item, NSError *error) {
        NSString *displayName = item[@"seller"][@"displayName"];
        NSString *phoneNumber = item[@"seller"][@"phoneNumber"];
        //NSLog(item[@"seller"][@"username"]);
        if (displayName == NULL){
            displayName = item[@"seller"][@"username"];
        }
        if (phoneNumber==NULL) {
            phoneNumber = @"N/A";
            cell.userInteractionEnabled = NO;
        } else{
            cell.userInteractionEnabled = YES;
        }
        cell.contact.text = [NSString stringWithFormat:@"%@:%@",displayName,phoneNumber];
        
        cell.category.text = item[@"category"][@"name"];
    }];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    PFObject *item = [self.objects objectAtIndex:indexPath.row];
    if ([[item[@"seller"] objectId] isEqualToString:[[PFUser currentUser] objectId]]){
        return YES;
    }
    return NO;
}

//swipe editing related
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self loadObjects];
        }];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Text Owner", @"Voice Call Owner",nil];
    actionSheet.tag = 2;
    [actionSheet showInView:self.view];
    
    //Adding phoen number
    PFObject *p = [self objectAtIndexPath:indexPath];
    [p fetchIfNeeded];
    PFUser * u = [p objectForKey:@"seller"];
    [u fetchIfNeeded];
    NSString *phone = [u objectForKey:@"phoneNumber"];
    self.recipients = [[NSMutableArray alloc] init];
    [self.recipients addObject:phone];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

-(void)imgToFullScreen:(UIImageView *)view{
    if (!self.isFullScreen) {
        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
            //save previous frame
            self.prevFrame = view.frame;
            [view setFrame:[[UIScreen mainScreen] bounds]];
        }completion:^(BOOL finished){
            self.isFullScreen = true;
        }];
        return;
    }
    else{
        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
            [view setFrame:self.prevFrame];
        }completion:^(BOOL finished){
            self.isFullScreen = false;;
        }];
        return;
    }
}
@end
