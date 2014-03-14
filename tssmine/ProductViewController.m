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


@interface ProductViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *productImageView;
@property (strong, nonatomic) IBOutlet UILabel *pTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *pPriceLabel;
@property (strong, nonatomic) IBOutlet UIButton *optionButton;
@property (strong, nonatomic) IBOutlet UIButton *ATCButton;
@property (strong, nonatomic) NSArray *options;
@property (strong, nonatomic) IBOutlet UIScrollView *productScrollView;
@property (strong) TSSOptionValue *chosenOptionValue;
@property (strong, nonatomic) IBOutlet UITextField *tr;

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
    [self.productImageView setImageWithURL:self.product.image];
    
    self.pTitleLabel.text = self.product.name;
    self.pPriceLabel.text = self.product.price;
    NSString *t = [NSString stringWithFormat:@"Select %@ >",self.product.option.name];
    [self.optionButton setTitle:t forState:UIControlStateNormal];
    self.productScrollView.delaysContentTouches = NO;
    
    UIImage *bG = [self imageWithColor:[UIColor colorWithRed:14.0/255.0 green:114.0/255.0 blue:199.0/255.0 alpha:1] andSize:CGSizeMake(199,32)];
    
    [self.ATCButton setBackgroundImage:bG forState:UIControlStateHighlighted];
    
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

- (IBAction)addToCart:(id)sender {
    
}

- (void)shoppingCart{
    CartViewController *cVC = [self.storyboard instantiateViewControllerWithIdentifier:@"cart"];
    [self.navigationController pushViewController:cVC animated:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.product.option.optionValues count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.product.option.optionValues[row] name];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.chosenOptionValue = self.product.option.optionValues[row];
    NSLog(@"chosen %@", [self.chosenOptionValue name]);
}

- (IBAction)choseOption:(id)sender {
    //[self.optionPicker setHidden:NO];
}

- (IBAction)tapATCButton:(id)sender {
    TSSOption * o = self.product.option;
    
    if (self.product.option.name != NULL) {
        NSString * l = [o.optionValues[0] name];
        NSLog(@"value is %@",l);
        if (self.chosenOptionValue == NULL) {
            NSString *message = [NSString stringWithFormat:@"You Must Select a %@ ", self.product.option.name];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:self.product.option.name
                                                         message:message
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil];
            [av show];
        }
    } else {
        NSLog(@"no option and directly ad");
    }
}

@end
