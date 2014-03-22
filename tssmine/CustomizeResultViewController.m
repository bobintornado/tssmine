//
//  CustomizeResultViewController.m
//  TheSMUShop
//
//  Created by Bob Cao on 28/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "CustomizeResultViewController.h"
#import "StyleCenter.h"
#import "CustomizeCell.h"
#import "TSSProduct.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "ProductViewController.h"


@interface CustomizeResultViewController ()

@property (strong, nonatomic) IBOutlet UITableView *productsTableView;

@property UIImage *upperImage;
@property UIImage *underImage;
@property UIImage *slipperImage;

@end

@implementation CustomizeResultViewController

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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    StyleCenter *sc = [StyleCenter sharedCenter];

    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:sc.upper.image options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
         if (image && finished){self.upperImage = image;}
     }];
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:sc.bottom.image options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
         if (image && finished){self.underImage = image;}
     }];
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:sc.slipper.image options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
         if (image && finished){self.slipperImage = image;}
     }];
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
    
    StyleCenter *sc = [StyleCenter sharedCenter];
    
    //Configure the cell
    if (indexPath.row == 0 ){
        [cell.productImage setImageWithURL:sc.upper.image];
    } else if (indexPath.row == 1){
         [cell.productImage setImageWithURL:sc.bottom.image];
    } else {
        [cell.productImage setImageWithURL:sc.slipper.image];
    }
    
    //return the cell
    return cell;
}
- (IBAction)shareCustomizedOutFit:(id)sender {
    //futher customization is needed
    NSString *shareString = @"Check out my newly crafted outfit at mySMU app! Browse more at products at http://shop.smu.edu.sg/store/";

    CGSize size = CGSizeMake(self.upperImage.size.width, self.upperImage.size.height + self.underImage.size.height + self.slipperImage.size.height);
    UIGraphicsBeginImageContext(size);
    
    [self.upperImage drawInRect:CGRectMake(0,0,size.width, self.upperImage.size.height)];
    [self.underImage drawInRect:CGRectMake(0,self.upperImage.size.height,size.width, self.underImage.size.height)];
    [self.slipperImage drawInRect:CGRectMake(0,self.upperImage.size.height + self.underImage.size.height ,size.width, self.underImage.size.height)];
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, finalImage.size.width, finalImage.size.height)];
    imageView.image = finalImage;
    
    //Get the image needed to shared before user clicks on sharing
    //PFFile *imageFile = [self.snapObject objectForKey:@"snapPicture"];
    //NSData *data = [imageFile getData];
    UIImage *shareImage = finalImage;
    
    //config the sharing
    NSArray *activityItems = [NSArray arrayWithObjects:shareString,shareImage,nil];
    
    //present the sharing window
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ProductViewController *pVC = [self.storyboard instantiateViewControllerWithIdentifier:@"productDetailView"];
    
    StyleCenter *sc = [StyleCenter sharedCenter];
    
    if (indexPath.row == 0 ){
        pVC.product = sc.upper;
    } else if (indexPath.row == 1){
        pVC.product = sc.bottom;
    } else {
        pVC.product = sc.slipper;
    }
    
    [self.navigationController pushViewController:pVC animated:YES];
}

@end
