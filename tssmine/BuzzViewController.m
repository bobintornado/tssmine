//
//  BuzzViewController.m
//  mySMU
//
//  Created by Bob Cao on 22/2/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "BuzzViewController.h"
#import "BuzzCell.h"
#import "Filter.h"
#import "SnapTakePhotoViewController.h"
#import "AppDelegate.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "TSSUtility.h"
#import "FilterCenter.h"

@interface BuzzViewController ()

@property UIImage *photoChosen;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (strong, nonatomic) FilterCenter *sharedCenter;
@property (strong, nonatomic) IBOutlet UITableView *buzzTable;

@end

@implementation BuzzViewController

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
    self.sharedCenter = [FilterCenter sharedCenter];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadNewBuzz) name:@"publishNew" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadObjects) name:@"changeRanking" object:nil];
    
    UIBarButtonItem *rank = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"text-list.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rank)];
    
    UIBarButtonItem *take = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takeSnap)];
                             
    //Adjust button spacing
    rank.imageInsets = UIEdgeInsetsMake(0.0, 0.0, 0, -30);
    
    NSArray *arr= [[NSArray alloc] initWithObjects:take,rank,nil];
    self.navigationItem.rightBarButtonItems=arr;
    
    
    PFObject *tracking = [PFObject objectWithClassName:@"tracking"];
    tracking[@"event"] = @"ClickOnTab";
    tracking[@"content"] = @"buzz";
    tracking[@"device"] = [PFInstallation currentInstallation];
    [tracking saveInBackground];
}
                             
-(void)takeSnap{
    if (![PFUser currentUser]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@""
                                                     message:@"You Need to Login/Sign Up in order to post a new buzz, tab Profile for more information"
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"OK", nil];
        [av show];
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Maybe Next Time" destructiveButtonTitle:nil otherButtonTitles:@"Snap A Photo", @"Choose Existing Photos",nil];
        [actionSheet showInView:self.view];
    }
}

- (void)rank{
    RankTableViewController *rTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"rankTVC"];
    [self.navigationController pushViewController:rTVC animated:YES];
}

//- (void)setRankingIndex:(RankTableViewController *)RankTableViewController{
//    self.rankingIndex = RankTableViewController.checkMarkIndex;
//}

- (void)uploadNewBuzz {
    SnapTakePhotoViewController *snapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"phototaking"];
    [snapViewController setSnapImage:self.photoChosen];
    [self presentViewController:snapViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        self.parseClassName = @"snap";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
    }
    return self;
}

- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:@"snap"];
    NSArray *objects = [query findObjects];
    
    if (self.sharedCenter.buzzFilter == 0) {
        for (PFObject *object in objects){
            PFQuery *thumbupCount = [PFQuery queryWithClassName:@"ThumbUp"];
            [thumbupCount whereKey:@"target" equalTo:object];
            NSDate *creationTime = [object createdAt];
            NSDate *now = [NSDate date];
            NSTimeInterval distanceBetweenDates = [now timeIntervalSinceDate:creationTime];
            double secondsInAnHour = 3600;
            NSInteger age = distanceBetweenDates / secondsInAnHour;
            [thumbupCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                object[@"score"] = @(number*50/pow((age + 2), 1.8));
                [object saveInBackground];
            }];
        }
        [query orderByDescending:@"score"];
    } else {
        [query addDescendingOrder:@"createdAt"];
    }
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    //mark cell indentifier in storyboard
    static NSString *CellIdentifier = @"buzzCell";
    
    //assign indentifer
    BuzzCell *cell = (BuzzCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //initilize with identifer
    if (cell == nil) {
        cell = [[BuzzCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    //query cell statistics
  
    
    PFQuery *thumbUpsCount = [[PFQuery alloc] initWithClassName:@"ThumbUp"];
    [thumbUpsCount whereKey:@"target" equalTo:object];
    [thumbUpsCount countObjectsInBackgroundWithBlock:^(int number, NSError *error){
        cell.thumbsups.text = [NSString stringWithFormat:@"%d ThumbUps", number];
        if ([PFUser currentUser]){
            //PFQuery *thumbUpsCount2 = [[PFQuery alloc] initWithClassName:@"ThumbUp"];
            [thumbUpsCount whereKey:@"fromUser" equalTo:[PFUser currentUser]];
            [thumbUpsCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                if (number>0){
                    cell.thumbUpButton.selected = true;
                }
            }];
        }
    }];

    
    // Configure the cell
    cell.buzzImg.file = [object objectForKey:@"snapPicture"];
    [cell.buzzImg loadInBackground];
    cell.buzzTitle.text = [object objectForKey:@"snapTitle"];
    cell.delegate = self;
    cell.buzzObject = object;
    cell.thumbUpButton.selected = false;
    
    //make button responsive
    for (id obj in cell.subviews)
    {
        if ([NSStringFromClass([obj class]) isEqualToString:@"UITableViewCellScrollView"])
        {
            UIScrollView *scroll = (UIScrollView *) obj;
            scroll.delaysContentTouches = NO;
            break;
        }
    }
    
    return cell;
}

//swipe editing related
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    PFObject *buzz = [self.objects objectAtIndex:indexPath.row];
    if ([[buzz[@"poster"] objectId] isEqualToString:[[PFUser currentUser] objectId]]){
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

- (IBAction)takeNewBuzz:(id)sender {
    if (![PFUser currentUser]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@""
                                                     message:@"You Need to Login/Sign Up in order to post a new buzz, tab Profile for more information"
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"OK", nil];
        [av show];
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Maybe Next Time" destructiveButtonTitle:nil otherButtonTitles:@"Snap A Photo", @"Choose Existing Photos",nil];
        [actionSheet showInView:self.view];
    }
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
    
    self.photoChosen = image;
    
    //use this method first, i still didn't get why this is happending
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"publishNew" object:nil]];
}


//thumb up related stuff below
- (void) buzzViewCell:(BuzzCell *)buzzViewCell didTapLikeButton:(UIButton *)button Buzz:(PFObject *)buzz{
    
    //disable thumbUp button
    [buzzViewCell shouldEnableThumbUpButton:NO];
    
    //get thumb up status from button selection status
    BOOL thumbuped = !button.selected;
    
    //Chose process based on button selection status
    if(thumbuped){
        [TSSUtility thumbUpBuzzInBackground:buzz block:^(BOOL succeeded, NSError *error){
            [buzzViewCell shouldEnableThumbUpButton:YES];
            [buzzViewCell.thumbUpButton setSelected:thumbuped];
            NSNumber *count= [NSNumber numberWithInt:[[buzzViewCell.thumbsups.text substringToIndex:2] intValue] + 1];
            buzzViewCell.thumbsups.text =  [NSString stringWithFormat:@"%@ ThumbUps",count];
            NSLog(@"like execute");
        }];
    } else {
        [TSSUtility unThumbUpBuzzInBackground:buzz block:^(BOOL succeeded, NSError *error){
            NSLog(@"unthumb testing log");
            [buzzViewCell shouldEnableThumbUpButton:YES];
            [buzzViewCell.thumbUpButton setSelected:thumbuped];
            NSNumber *count= [NSNumber numberWithInt:[[buzzViewCell.thumbsups.text substringToIndex:2] intValue] - 1];
            buzzViewCell.thumbsups.text =  [NSString stringWithFormat:@"%@ ThumbUps",count];
            NSLog(@"dislike execute");
        }];
    }
    
}


//fliter related stuff below
- (void)loadFiltersForImage:(UIImage *)image{
    CIImage *filterPreviewImage = [[CIImage alloc] initWithImage:image];
    
    //create filter 1
    CIFilter *sepiaFilter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues:kCIInputImageKey,filterPreviewImage, @"inputIntensity",[NSNumber numberWithFloat:0.8],nil];
    
    //create filter 2
    CIFilter *colorMonochrome = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues:kCIInputImageKey,filterPreviewImage, @"inputColor",[CIColor colorWithString:@"Red"], @"inputIntensity",[NSNumber numberWithFloat:0.8], nil];
    
    filters = [[NSMutableArray alloc] init];
    [filters addObjectsFromArray:[NSArray arrayWithObjects:[[Filter alloc] initWithNameAndFilter:@"Sepia" filter:sepiaFilter],[[Filter alloc] initWithNameAndFilter:@"Mono" filter:colorMonochrome], nil]];
    
    [self createPreviewViewsForFilters];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) createPreviewViewsForFilters
{
    int offsetX = 0;
    for(int index = 0; index < [filters count]; index++)
    {
        UIView *filterView = [[UIView alloc] initWithFrame:CGRectMake(offsetX, 0, 60, 60)];
        // create a label to display the name
        UILabel *filterNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, filterView.bounds.size.width, 8)];
        filterNameLabel.center = CGPointMake(filterView.bounds.size.width/2, filterView.bounds.size.height + filterNameLabel.bounds.size.height);

        Filter *filter = (Filter *) [filters objectAtIndex:index];

        filterNameLabel.text =  filter.name;
        
        filterNameLabel.backgroundColor = [UIColor clearColor];
        filterNameLabel.textColor = [UIColor whiteColor];
        
        filterNameLabel.font = [UIFont fontWithName:@"AppleColorEmoji" size:10];
        
        //filterNameLabel.textAlignment = UITextAlignmentCenter;
        CIImage *outputImage = [filter.filter outputImage];
        CGImageRef cgimg =
        [context createCGImage:outputImage fromRect:[outputImage extent]];

        UIImage *smallImage =  [UIImage imageWithCGImage:cgimg];
        // create filter preview image views
        UIImageView *filterPreviewImageView = [[UIImageView alloc] initWithImage:smallImage];
        [filterView setUserInteractionEnabled:YES];
        filterPreviewImageView.layer.cornerRadius = 10;
        filterPreviewImageView.opaque = NO;
        filterPreviewImageView.backgroundColor = [UIColor clearColor];
        filterPreviewImageView.layer.masksToBounds = YES;
        filterPreviewImageView.frame = CGRectMake(0, 0, 60, 60);
        filterView.tag = index;
        [self applyGesturesToFilterPreviewImageView:filterView];
        [filterView addSubview:filterPreviewImageView];
        [filterView addSubview:filterNameLabel];
        [self.filtersScrollView addSubview:filterView];
        offsetX += filterView.bounds.size.width + 10;
        
    }
    [self.filtersScrollView setContentSize:CGSizeMake(400, 60)];
}

-(void) applyGesturesToFilterPreviewImageView:(UIView *) view
{
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(applyFilter:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [view addGestureRecognizer:singleTapGestureRecognizer];
}

-(void) applyFilter:(id) sender
{
    int filterIndex = [(UITapGestureRecognizer *) sender view].tag;
    
    Filter *filter = [filters objectAtIndex:filterIndex];

    CIImage *outputImage = [filter.filter outputImage];
    
    CGImageRef cgimg =
    [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *finalImage = [UIImage imageWithCGImage:cgimg];
    //finalImage = [finalImage imageRotatedByDegrees:90];
    [self.imageView setImage:finalImage];
    CGImageRelease(cgimg);
}

@end
