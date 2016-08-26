//
//  ViewController.m
//  ARPaymentItemizedView
//
//  Created by Alex Reynolds on 8/26/16.
//  Copyright © 2016 Alex Reynolds. All rights reserved.
//

#import "ViewController.h"
#import "ARPaymentSummaryView.h"

@interface ViewController ()
@property (nonatomic, strong) ARPaymentSummaryView *summaryView;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *costField;
@property (nonatomic, strong) NSArray *items;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.items = @[];
    self.summaryView = [[ARPaymentSummaryView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
    [self.view addSubview:self.summaryView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)updateSummary
{
    NSMutableArray *array = [self.items mutableCopy];
    NSArray *costs = [self.items valueForKey:@"amount"];
    NSNumber* sum = [costs valueForKeyPath: @"@sum.self"];

    ARPaymentSummaryItem *item = [ARPaymentSummaryItem summaryItemWithLabel:@"total" amount:[[NSDecimalNumber alloc] initWithDouble:[sum doubleValue]]];
    [array addObject:item];
    self.summaryView.paymentSummaryItems = array;
    CGSize size = [self.summaryView systemLayoutSizeFittingSize:CGSizeMake(self.view.bounds.size.width, -1.0) withHorizontalFittingPriority:UILayoutPriorityRequired verticalFittingPriority:UILayoutPriorityDefaultLow];
    self.summaryView.frame = CGRectMake(0, 0, size.width, size.height);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPressed:(id)sender {
    ARPaymentSummaryItem *item = [ARPaymentSummaryItem summaryItemWithLabel:self.nameField.text amount:[[NSDecimalNumber alloc] initWithDouble:[self.costField.text doubleValue]]];
    self.items = [self.items arrayByAddingObject:item];
    [self updateSummary];
}
@end
