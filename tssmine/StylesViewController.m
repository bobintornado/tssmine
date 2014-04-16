//
//  StylesViewController.m
//  mySMUShop
//
//  Created by Bob Cao on 31/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "StylesViewController.h"
#import "TSSProduct.h"
#import "NSString+HTML.h"
#import "TSSOption.h"
#import "TSSOptionValue.h"
#import "QuizResultViewController.h"

@interface StylesViewController ()

@property (strong,nonatomic) NSMutableArray *products;
@property (strong,nonatomic) NSDictionary *results;

@end

@implementation StylesViewController

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
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = NO;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:@"Style"];
    [query whereKey:@"user" equalTo: [PFUser currentUser]];
    return query;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"My Style";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.products = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"stylesViewCell";
    //NSLog(@"%@", @"22");
    //assign indentifer
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = [object objectForKey:@"name"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.results = [[self objectAtIndexPath:indexPath] valueForKey:@"style"];
    for (NSObject *ob in [self.results valueForKey:@"products"]){
        TSSProduct *pr = [[TSSProduct alloc] init];
        pr.options = [[NSMutableArray alloc] init];
        
        pr.productID = [ob valueForKey:@"id"];
        pr.name =  [[ob valueForKey:@"name"] stringByConvertingHTMLToPlainText];
        
        NSString *urlText = [[ob valueForKey:@"thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        pr.thumbURL = [NSURL URLWithString:urlText];
        urlText = [[ob valueForKey:@"image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        pr.image = [NSURL URLWithString: urlText];
        
        pr.images = [[NSMutableArray alloc] init];
        for (NSString *imageULRStr in [ob valueForKeyPath:@"images"]) {
            NSString *urlText = [imageULRStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [pr.images addObject:urlText];
        }
        
        pr.pDescription = [[ob valueForKey:@"description"] stringByConvertingHTMLToPlainText];
        pr.price = [NSString stringWithFormat:@"%@",[ob valueForKey:@"pirce"]];
        
        
        
        for (NSObject *op in [ob valueForKey:@"options"]) {
            TSSOption *pop = [[TSSOption alloc] init];
            pop.product_option_id = [op valueForKey:@"product_option_id"];
            pop.optionId = [op valueForKey:@"option_id"];
            pop.name = [op valueForKey:@"name"];
            
            pop.optionValues = [[NSMutableArray alloc] init];
            
            if ([[op valueForKey:@"option_value"] isKindOfClass:[NSArray class]]) {
                for (NSObject *opv in [op valueForKey:@"option_value"]){
                    TSSOptionValue *v = [[TSSOptionValue alloc] init];
                    v.product_option_value_id = [opv valueForKey:@"product_option_value_id"];
                    v.option_value_id = [opv valueForKey:@"option_value_id"];
                    v.name = [opv valueForKey:@"name"];
                    [pop.optionValues addObject:v];
                }
            } else {
                NSLog(@"non array option");
            }
            [pr.options addObject:pop];
        }
        
        [self.products addObject:pr];
    }
    QuizResultViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"quizResult"];
    vc.products = self.products;
    vc.results = self.results;
    self.products = [[NSMutableArray alloc] init];
    self.results = [[NSDictionary alloc] init];
    vc.title = [[self objectAtIndexPath:indexPath] valueForKey:@"name"];
    [self.navigationController pushViewController:vc animated:YES];
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
