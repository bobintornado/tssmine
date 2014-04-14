//
//  ProductViewController.m
//  mySMU
//
//  Created by Bob Cao on 11/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "ProductViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MYSMUConstants.h"
#import "CartViewController.h"
#import "TSSOption.h"
#import "TSSOptionValue.h"
#import "OptionTableViewController.h"
#import "ImageContentViewController.h"

@interface ProductViewController ()

//@property (strong, nonatomic) IBOutlet UIImageView *productImageView;
@property (strong, nonatomic) IBOutlet UILabel *pTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *pPriceLabel;
@property (strong, nonatomic) IBOutlet UIButton *optionButton;
@property (strong, nonatomic) IBOutlet UIButton *ATCButton;
@property (strong, nonatomic) NSArray *options;
@property (strong, nonatomic) IBOutlet UIScrollView *productScrollView;
@property (strong) TSSOptionValue *chosenOptionValue;
@property (strong, nonatomic) IBOutlet UILabel *desContent;

@property (strong, nonatomic) UIPageViewController *imagePVC;
@property (strong, nonatomic) NSMutableArray *imageCVCs;
@property (strong, nonatomic) IBOutlet UIView *viewInsideScrollView;

@end

@implementation ProductViewController


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
    
    self.title = self.product.name;
    
    //set images
    self.imageCVCs = [[NSMutableArray alloc] init];
    self.imagePVC = [self.storyboard instantiateViewControllerWithIdentifier:@"imagePVC"];
    //self.imagePVC = [[UIPageViewController alloc] init];
    self.imagePVC.dataSource = self;
    //set up content view controllers
    [self getImages];
    
    //set name and price
    self.pTitleLabel.text = self.product.name;
    self.pPriceLabel.text = self.product.price;
    //set option if have
    if (self.product.option.name != NULL) {
        NSString *t = [NSString stringWithFormat:@"Select %@ >",self.product.option.name];
        [self.optionButton setTitle:t forState:UIControlStateNormal];
    } else {
        self.optionButton.hidden = YES;
    }
    
    self.productScrollView.delaysContentTouches = NO;
    
    //description
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:14];
    CGSize constraint = CGSizeMake(280,NSUIntegerMax);
    
    NSDictionary *attributes = @{NSFontAttributeName: font};

    CGRect rect = [self.product.pDescription boundingRectWithSize:constraint options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
    
    self.desContent.frame = CGRectMake(20, 525, rect.size.width, rect.size.height);
    [self.desContent setText:self.product.pDescription];
    [self.desContent setTextAlignment:NSTextAlignmentLeft];
    self.desContent.lineBreakMode = NSLineBreakByWordWrapping;
    self.desContent.numberOfLines = 0;
    [self.desContent setFont:font];
    
    //reconfig this part later
    self.productScrollView.contentSize =CGSizeMake(320, rect.size.height + 540);
    
    //button
    UIImage *bG = [self imageWithColor:[UIColor colorWithRed:14.0/255.0 green:114.0/255.0 blue:199.0/255.0 alpha:1] andSize:CGSizeMake(199,32)];
    [self.ATCButton setBackgroundImage:bG forState:UIControlStateHighlighted];
    
    //navigation
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cart.png"] style:UIBarButtonItemStylePlain target:self action:@selector(shoppingCart)];
}

-(void)getImages{
    if ([self.product.images count] > 0) {
        for (NSString *imageURLStr in self.product.images) {
            ImageContentViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"imageContentVC"];
            vc.imageURLStr = imageURLStr;
            [self.imageCVCs addObject:vc];
        }
        ImageContentViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"imageContentVC"];
        vc.imageURLStr = [self.product.image absoluteString];
        [self.imageCVCs insertObject:vc atIndex:0];
        NSArray *array = @[[self.imageCVCs objectAtIndex:0]];
        [self.imagePVC setViewControllers:array direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        //adjust later
        self.imagePVC.view.frame = CGRectMake(0, 0, 320, 320);
        
        [self addChildViewController:self.imagePVC];
        [self.productScrollView addSubview:self.imagePVC.view];
        [self.imagePVC didMoveToParentViewController:self];

        //[self.viewInsideScrollView bringSubviewToFront:self.imagePVC.view];
    } else {
        //do nothing
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    int vcIndex = [self.imageCVCs indexOfObject:viewController];
    
    if (vcIndex == 0) {
        vcIndex = self.imageCVCs.count - 1;
    } else {
        vcIndex--;
    }
    
    return self.imageCVCs[vcIndex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    int vcIndex = [self.imageCVCs indexOfObject:viewController];
    
    if (vcIndex == (self.imageCVCs.count - 1)) {
        vcIndex = 0;
    } else {
        vcIndex++;
    }
    
    return self.imageCVCs[vcIndex];
}

- (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shoppingCart{
    CartViewController *cVC = [self.storyboard instantiateViewControllerWithIdentifier:@"cart"];
    [self.navigationController pushViewController:cVC animated:YES];
}

- (IBAction)choseOption:(id)sender {
    //[self.optionPicker setHidden:NO];
    OptionTableViewController *otvc = [self.storyboard instantiateViewControllerWithIdentifier:@"optionTVC"];
    otvc.option = self.product.option;
    otvc.delegate = self;
    [self.navigationController pushViewController:otvc animated:YES];
}

- (IBAction)tapATCButton:(id)sender {
    if (self.product.option.name != NULL) {
        if (self.chosenOptionValue == NULL) {
            NSString *message = [NSString stringWithFormat:@"You Must Select a %@ ", self.product.option.name];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:self.product.option.name
                                                         message:message
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil];
            [av show];
        } else {
            NSString * str = [NSString stringWithFormat:@"%@index.php?route=feed/web_api/add",ShopDomain];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:str]];
            [request setHTTPMethod:@"POST"];
            NSString *postString = [NSString stringWithFormat:@"product_id=%@&option[%@]=%@", self.product.productID, self.product.option.product_option_id, self.chosenOptionValue.product_option_value_id];
            [request setValue:[NSString stringWithFormat:@"%d", [postString length]] forHTTPHeaderField:@"Content-length"];
            [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
            [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                if (error) {
                    NSLog(@"adding product into cart failed");
                } else {
                    NSError *localError = nil;
                    id parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
                    if ([parsedObject isKindOfClass:[NSDictionary class]]) {
                        NSLog(@"successfully add in new products. indicator undone");
                    }
                }
                [self performSelectorOnMainThread:@selector(shoppingCart) withObject:self waitUntilDone:NO];
            }];
           
        }
    } else {
        NSString * str = [NSString stringWithFormat:@"%@index.php?route=feed/web_api/add",ShopDomain];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:str]];
        [request setHTTPMethod:@"POST"];
        NSString *postString = [NSString stringWithFormat:@"product_id=%@", self.product.productID];
        [request setValue:[NSString stringWithFormat:@"%d", [postString length]] forHTTPHeaderField:@"Content-length"];
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (error) {
                NSLog(@"adding product into cart failed");
            }
            [self performSelectorOnMainThread:@selector(shoppingCart) withObject:self waitUntilDone:NO];
        }];
    }
}

- (void)setChosenOption:(OptionTableViewController *)OptionTableViewController{
    self.chosenOptionValue = OptionTableViewController.chosenOptionValue;
    NSString *t = [NSString stringWithFormat:@"%@ : %@",self.product.option.name ,self.chosenOptionValue.name];
    [self.optionButton setTitle:t forState:UIControlStateNormal];
}

@end
