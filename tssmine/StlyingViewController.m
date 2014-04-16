//
//  StlyingViewController.m
//  tssmine
//
//  Created by Bob Cao on 14/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "StlyingViewController.h"
#import "QuizCenter.h"
#import "TSSProduct.h"
#import "MYSMUConstants.h"
#import "NSString+HTML.h"
#import "TSSOption.h"
#import "TSSOptionValue.h"
#import "QuizResultViewController.h"
#import "NSString+HTML.h"

@interface StlyingViewController ()

@property (strong,nonatomic) NSMutableArray *products;
@property (strong,nonatomic) NSDictionary *results;

@end

@implementation StlyingViewController

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
    NSLog(@"styling");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushViews) name:@"popBack" object:nil];
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"inbox.png"] style:UIBarButtonItemStylePlain target:self action:@selector(savedStyles)];
	
    //Tracking based on "impression"
    PFObject *tracking = [PFObject objectWithClassName:@"tracking"];
    tracking[@"event"] = @"ClickOnTab";
    tracking[@"content"] = @"styling";
    tracking[@"device"] = [PFInstallation currentInstallation];
    [tracking saveInBackground];
}

- (void)savedStyles{
    if (![PFUser currentUser]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@""
                                                     message:@"Please Login To View Your Saved Styles"
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"OK", nil];
        [av show];
    } else {
        UITableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"stylesViewer"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViews {
    //Pop back to the root view controller
    QuizCenter *qz = [QuizCenter sharedCenter];
    self.products = [[NSMutableArray alloc] init];

    NSString *urlString = [NSString stringWithFormat:@"%@index.php?route=%@&key=%@&code=%@",ShopDomain,@"feed/web_api/quiz",RESTfulKey,qz.result];
    //NSLog(@"and the calling url is .. %@",urlString);
    NSURL *quizURL = [NSURL URLWithString:urlString];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:quizURL] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"fetching products data failed");
        } else {
            NSError *localError = nil;
            id parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            
            if([parsedObject isKindOfClass:[NSDictionary class]])
            {
                //saving information to dictionaries
                self.results = parsedObject;
                //construct objects and pass to array
                NSLog(@"products is dict");
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
            } else {
                NSLog(@"what we get is not a kind of clss nsdictionary class");
            }
        }
        [self performSelectorOnMainThread:@selector(showResult) withObject:nil waitUntilDone:NO];
    }];
}

- (void)showResult{
    QuizResultViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"quizResult"];
    vc.products = self.products;
    vc.results = self.results;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)createStyle:(id)sender {
    [self performSegueWithIdentifier:@"createStyle" sender:self];
}

- (IBAction)takeQuiz:(id)sender {
    [self performSegueWithIdentifier:@"stylingQuiz" sender:self];
}


@end
