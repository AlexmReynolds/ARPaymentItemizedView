//
//  BCPaymentSummaryView.m
//  corsssell
//
//  Created by Alex Reynolds on 8/25/16.
//  Copyright © 2016 Alex Reynolds. All rights reserved.
//

#import "ARPaymentSummaryView.h"
#import "ARPaymentSummaryItemView.h"

@implementation ARPaymentSummaryItem
+ (instancetype)summaryItemWithLabel:(NSString *)label amount:(NSDecimalNumber *)amount
{
    ARPaymentSummaryItem *item = [[ARPaymentSummaryItem alloc] init];
    item.label = label;
    item.amount = amount;
    return item;
}

@end

@interface ARPaymentSummaryView()
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@property (nonatomic, strong) NSLayoutConstraint *constriantToLastItem;
@end
@implementation ARPaymentSummaryView{
    NSMutableArray *_itemViews;
}

- (instancetype)init
{
    self = [super init];
    self.insetsForSummaryItems = UIEdgeInsetsMake(4, 100, 4, 16);
    self.minimumItemSpacing = 3.0;
    self.spacingToLastItem = 6.0;
    self.backgroundColor = [UIColor whiteColor];
    return self;
}

- (NSNumberFormatter *)numberFormatter
{
    if (_numberFormatter == nil){
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.currencyCode = self.currencyCode;
        _numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    }
    
    return _numberFormatter;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
}
- (void)setPaymentSummaryItems:(NSArray<ARPaymentSummaryItem *> *)paymentSummaryItems
{
    _paymentSummaryItems = paymentSummaryItems;
    [_itemViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _itemViews = [NSMutableArray array];
    if (paymentSummaryItems.count)
        [self addViewsForSummaryItems:paymentSummaryItems];
}

- (void)addViewsForSummaryItems:(NSArray<ARPaymentSummaryItem *> *)items
{
    [items enumerateObjectsUsingBlock:^(ARPaymentSummaryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addViewForSummaryItem:obj];
    }];
}

- (void)addViewForSummaryItem:(ARPaymentSummaryItem *)item
{
    NSArray *nibContents = [[NSBundle bundleForClass:[self class]] loadNibNamed:@"ARPaymentSummaryItemView" owner:nil options:nil];
    ARPaymentSummaryItemView *itemView = [nibContents lastObject];
    itemView.titleLabel.text = [item.label uppercaseString];
    itemView.titleLabel.textColor = [UIColor darkTextColor];
    itemView.amountLabel.text = [self.numberFormatter stringFromNumber:item.amount];
    itemView.amountLabel.font = [UIFont fontWithName:itemView.amountLabel.font.fontName size:itemView.amountLabel.font.pointSize + 4.0]; //Make it bigger assuming this is the last item

    itemView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:itemView];
    
    ARPaymentSummaryItemView *previousView = [_itemViews lastObject];
    previousView.titleLabel.textColor = [UIColor lightGrayColor];
    previousView.amountLabel.font = [UIFont fontWithName:previousView.amountLabel.font.fontName size:previousView.titleLabel.font.pointSize];//Since the previous view is no longer the last item, make smaller
    self.constriantToLastItem.constant = self.minimumItemSpacing;
    
    //Apply new constraints
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:itemView.superview attribute:NSLayoutAttributeLeading multiplier:1.0 constant:self.insetsForSummaryItems.left];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:itemView.superview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:itemView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:self.insetsForSummaryItems.right];
    NSLayoutConstraint *top;
    if ([_itemViews lastObject]){
        top = [NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:self.spacingToLastItem];
        self.constriantToLastItem = top;

    } else {
        top = [NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:itemView.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.insetsForSummaryItems.top];
    }
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:itemView.superview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:itemView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:self.insetsForSummaryItems.bottom];
    
    [self addConstraints:@[left, right, top, bottom]];
    
    [_itemViews addObject:itemView];
}

@end
