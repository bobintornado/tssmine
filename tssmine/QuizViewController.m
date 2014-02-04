//
//  QuizViewController.m
//  TheSMUShop
//
//  Created by Bob Cao on 27/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "QuizViewController.h"
#import "CustomizeCell.h"
#import "QuizCenter.h"

@interface QuizViewController ()

@property (strong, nonatomic) IBOutlet UINavigationBar *quizResultNavBar;
@property (strong,nonatomic) PFFile *upper;
@property (strong,nonatomic) PFFile *under;
@property (strong,nonatomic) PFFile *bottom;

@end

@implementation QuizViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        //Query
        PFQuery *query = [PFQuery queryWithClassName:@"Combo"];
        [query includeKey:@"Upper"];
        [query includeKey:@"Under"];
        [query includeKey:@"Bottom"];
        QuizCenter *shareCenter = [QuizCenter sharedCenter];
        [query whereKey:@"Answers" equalTo:shareCenter.result];
        PFObject *combo = [[query findObjects] firstObject];
        
        //Products
        PFObject *upperProduct = [combo objectForKey:@"Upper"];
        PFObject *underProduct = [combo objectForKey:@"Under"];
        PFObject *bottomProduct = [combo objectForKey:@"Bottom"];
        
        //Files
        self.upper = [upperProduct objectForKey:@"PreviewImage"];
        self.under = [underProduct objectForKey:@"PreviewImage"];
        self.bottom = [bottomProduct objectForKey:@"PreviewImage"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    //adding Title
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = @"Styling";
    
    //set left button for cancel
    UIBarButtonItem *leftCancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelQuizStyling:)];
    
    //set right button as the sharing action button
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareStyling)];
    
    //Adding two buttons
    navItem.leftBarButtonItem = leftCancelButton;
    navItem.rightBarButtonItem = rightButton;
    self.quizResultNavBar.items = @[ navItem ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //mark cell indentifier in storyboard
    static NSString *CellIdentifier = @"CustomizeCell";
    
    //Assign indentifer
    CustomizeCell *cell = (CustomizeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //Configure the cell
    if (indexPath.row == 0 ){
        cell.productImage.file = self.upper;
        [cell.productImage loadInBackground];
    } else if (indexPath.row == 1){
        cell.productImage.file = self.under;
        [cell.productImage loadInBackground];
    } else {
        cell.productImage.file = self.bottom;
        [cell.productImage loadInBackground];
    }

    //return the cell
    return cell;
}

- (void)cancelQuizStyling:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)shareStyling{
    //futher customization is needed
    NSString *shareString = @"My style!";
    
    //Get the image needed to shared before user clicks on sharing
    //PFFile *imageFile = [self.snapObject objectForKey:@"snapPicture"];
    //NSData *data = [imageFile getData];
    //UIImage *shareImage = [UIImage imageWithData:data];
    
    //config the sharing
    NSArray *activityItems = [NSArray arrayWithObjects:shareString, nil];
    
    //present the sharing window
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:activityViewController animated:YES completion:nil];
}

@end
