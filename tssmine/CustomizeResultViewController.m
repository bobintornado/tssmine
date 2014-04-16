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
#import "MYSMUConstants.h"


@interface CustomizeResultViewController ()

@property (strong, nonatomic) IBOutlet UITableView *productsTableView;
@property (strong, nonatomic) NSMutableArray *results;

@property (strong, nonatomic) NSDictionary *styleDic;

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
    
    self.title = @"Your Own SMU Style!";
    
    //Adding save and share button
    UIBarButtonItem *saveStyleButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"save.png"] style:UIBarButtonItemStylePlain target:self action:@selector(saveStyle)];
    
    UIBarButtonItem *shareStyleButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UIBarButtonAction_2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(shareStyle)];
    
    //Adjust button spacing
    saveStyleButton.imageInsets = UIEdgeInsetsMake(0.0, 0.0, 0, -30);
    
    NSArray *arr= [[NSArray alloc] initWithObjects:shareStyleButton,saveStyleButton,nil];
    self.navigationItem.rightBarButtonItems=arr;
    
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
    
    [self createStyleDict];
}

- (void)createStyleDict{
    StyleCenter *sc = [StyleCenter sharedCenter];
    self.results = [[NSMutableArray alloc] init];
    [self getproduct:sc.upper.productID];
    [self getproduct:sc.bottom.productID];
    [self getproduct:sc.slipper.productID];
    
    NSArray *keys = [NSArray arrayWithObjects:@"products", nil];
    NSArray *objects = [NSArray arrayWithObjects:self.results, nil];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects
                                                           forKeys:keys];
    self.styleDic = dictionary;
}

- (void)getproduct:(NSString *)productId{
    
    NSString *urlString = [NSString stringWithFormat:@"%@index.php?route=%@&key=%@&id=%@",ShopDomain,@"feed/web_api/product",RESTfulKey,productId, nil];

    NSURL *productURL = [NSURL URLWithString:urlString];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:productURL] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"fetching products data failed");
        } else {
            NSLog(@"start fetching products data");
            NSError *localError = nil;
            id parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            
            if([parsedObject isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *d = (NSDictionary *)parsedObject;
                [self.results addObject:[d valueForKey:@"product"]];
            } else {
                NSLog(@"what we get is not a kind of clss nsdictionary class");
            }
        }
    }];
}

- (void)saveStyle{
    if (![PFUser currentUser]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@""
                                                     message:@"Please Login To Save the Style"
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"OK", nil];
        [av show];
    } else {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Styles"
                                                     message:@"Name Your Style!"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"Save", nil];
        
        av.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * alertTextField = [av textFieldAtIndex:0];
        alertTextField.placeholder = @"Enter Your Style Name";
        av.tag = 1;
        [av show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        if (buttonIndex == [alertView cancelButtonIndex] ) {
            //do nothing
        } else {
            PFObject *style = [PFObject objectWithClassName:@"Style"];
            style[@"user"] = [PFUser currentUser];
            style[@"style"] = self.styleDic;
            style[@"name"] = [[alertView textFieldAtIndex:0] text];
            [style saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@""
                                                                 message:@"The Style Has Been Saved!"
                                                                delegate:self
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:@"OK", nil];
                    [av show];
                }
            }];
        }
    }
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

- (void)shareStyle {
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
