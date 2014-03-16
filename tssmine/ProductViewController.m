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


@interface ProductViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *productImageView;
@property (strong, nonatomic) IBOutlet UILabel *pTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *pPriceLabel;
@property (strong, nonatomic) IBOutlet UIButton *optionButton;
@property (strong, nonatomic) IBOutlet UIButton *ATCButton;
@property (strong, nonatomic) NSArray *options;
@property (strong, nonatomic) IBOutlet UIScrollView *productScrollView;
@property (strong) TSSOptionValue *chosenOptionValue;
@property (strong, nonatomic) IBOutlet UILabel *desContent;

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
    
    [self.productImageView setImageWithURL:self.product.image];
    self.pTitleLabel.text = self.product.name;
    self.pPriceLabel.text = self.product.price;
    NSString *t = [NSString stringWithFormat:@"Select %@ >",self.product.option.name];
    [self.optionButton setTitle:t forState:UIControlStateNormal];
    self.productScrollView.delaysContentTouches = NO;
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:14];
    CGSize constraint = CGSizeMake(280,NSUIntegerMax);
    
    NSDictionary *attributes = @{NSFontAttributeName: font};

    CGRect rect = [self.product.pDescription boundingRectWithSize:constraint options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
    
    self.desContent.frame = CGRectMake(20, 450, rect.size.width, rect.size.height);
    [self.desContent setText:self.product.pDescription];
    [self.desContent setTextAlignment:NSTextAlignmentLeft];
    self.desContent.lineBreakMode = NSLineBreakByWordWrapping;
    self.desContent.numberOfLines = 0;
    [self.desContent setFont:font];
    
    //reconfig this part later
    self.productScrollView.contentSize =CGSizeMake(320, rect.size.height + 550);
    
    //button
    UIImage *bG = [self imageWithColor:[UIColor colorWithRed:14.0/255.0 green:114.0/255.0 blue:199.0/255.0 alpha:1] andSize:CGSizeMake(199,32)];
    [self.ATCButton setBackgroundImage:bG forState:UIControlStateHighlighted];
    
    //navigation
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(shoppingCart)];
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
            NSString * str = [NSString stringWithFormat:@"%@index.php?route=feed/web_api/addToCart",ShopDomain];
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
            }];
        }
    } else {
        NSString * str = [NSString stringWithFormat:@"%@index.php?route=feed/web_api/addToCart",ShopDomain];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:str]];
        [request setHTTPMethod:@"POST"];
        NSString *postString = [NSString stringWithFormat:@"product_id=%@", self.product.productID];
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
        }];
    }
}

- (void)setChosenOption:(OptionTableViewController *)OptionTableViewController{
    self.chosenOptionValue = OptionTableViewController.chosenOptionValue;
    NSString *t = [NSString stringWithFormat:@"%@ : %@",self.product.option.name ,self.chosenOptionValue.name];
    [self.optionButton setTitle:t forState:UIControlStateNormal];
}

@end
