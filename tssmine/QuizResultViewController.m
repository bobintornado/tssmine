//
//  QuizResultViewController.m
//  mySMUShop
//
//  Created by Bob Cao on 21/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "QuizResultViewController.h"
#import "QuizTableViewCell.h"
#import "TSSProduct.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "ProductViewController.h"
#import "TSSProduct.h"

@interface QuizResultViewController ()

@property (strong,nonatomic) NSMutableArray *pictures;

@property (strong, nonatomic) IBOutlet UITableView *quizTable;

@end

@implementation QuizResultViewController

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
    self.title = @"Your SMU Style!";
    
    //Adding save and share button
    UIBarButtonItem *saveStyleButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"save.png"] style:UIBarButtonItemStylePlain target:self action:@selector(saveStyle)];
    
    UIBarButtonItem *shareStyleButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UIBarButtonAction_2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(shareStyle)];
    
    //Adjust button spacing
    saveStyleButton.imageInsets = UIEdgeInsetsMake(0.0, 0.0, 0, -30);

    NSArray *arr= [[NSArray alloc] initWithObjects:shareStyleButton,saveStyleButton,nil];
    self.navigationItem.rightBarButtonItems=arr;
    
    [self downloadImages];
}

- (void)downloadImages{
    self.pictures = [NSMutableArray arrayWithObjects: @"Upper", @"Bottom", @"Slipper", nil];
    for (TSSProduct *p in self.products){
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[p image] options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
         {
             if (image && finished)
             {
                 NSInteger anIndex = [self.products indexOfObject:p];
                 [self.pictures replaceObjectAtIndex:anIndex withObject:image];
             }
         }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuizTableViewCell *cell = (QuizTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"stylingCell" forIndexPath:indexPath];
    
    TSSProduct *pr = self.products[indexPath.row];
    [cell.previewImageView setImageWithURL:pr.image usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TSSProduct *product = self.products[indexPath.row];
    
    ProductViewController *pVC = [self.storyboard instantiateViewControllerWithIdentifier:@"productDetailView"];
    
    pVC.product = product;
    
    [self.navigationController pushViewController:pVC animated:YES];
}

- (void)shareStyle{
    NSString *shareString = @"Check out your SMU Style at mySMUShop app styling quiz! Browse more at http://shop.smu.edu.sg/store/ #mySMUShop";
    
    CGSize size = CGSizeMake(0.0,0.0);
    for (UIImage *i in self.pictures){
        size =CGSizeMake(i.size.width, size.height + i.size.height);
    }
    
    UIGraphicsBeginImageContext(size);
    int startingHeight = 0;
    for (UIImage *i in self.pictures){
        [i drawInRect:CGRectMake(0,startingHeight,size.width, i.size.height)];
        startingHeight = startingHeight + i.size.height;
    }
    UIImage *sharedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //config the sharing
    NSArray *activityItems = [NSArray arrayWithObjects:shareString,sharedImage,nil];
    
    //present the sharing window
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:activityViewController animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
