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

@interface QuizResultViewController ()

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
    // Do any additional setup after loading the view.
    NSLog(@"sdaf");
    [self.quizTable reloadData];
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
    //QuizTableViewCell *cell = [[QuizTableViewCell alloc] init];
    
    QuizTableViewCell *cell = (QuizTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"stylingCell" forIndexPath:indexPath];
    TSSProduct *pr = self.products[indexPath.row];
    
   [cell.previewImageView setImageWithURL:pr.image usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    NSLog(@"d %@", [pr.image absoluteString]);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TSSProduct *product = self.products[indexPath.row];
    
    ProductViewController *pVC = [self.storyboard instantiateViewControllerWithIdentifier:@"productDetailView"];
    
    pVC.product = product;
    
    [self.navigationController pushViewController:pVC animated:YES];
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
