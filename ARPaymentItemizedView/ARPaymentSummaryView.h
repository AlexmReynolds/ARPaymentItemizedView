//
//  BCPaymentSummaryView.h
//  corsssell
//
//  Created by Alex Reynolds on 8/25/16.
//  Copyright © 2016 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ARPaymentSummaryItem : NSObject

+ (instancetype)summaryItemWithLabel:(NSString *)label amount:(NSDecimalNumber *)amount;

// A short localized description of the item, e.g. "Tax" or "Gift Card".
@property (nonatomic, copy) NSString *label;

// Same currency as the enclosing PKPaymentRequest.  Negative values are permitted, for example when
// redeeming a coupon. An amount is always required unless the summary item's type is set to pending
@property (nonatomic, copy) NSDecimalNumber *amount;

@end

@interface ARPaymentSummaryView : UIView
// Currency code for this payment.
@property (nonatomic, copy) NSString *currencyCode;
// Array of BCPaymentSummaryItem objects which should be presented to the user.
// The last item should be the total you wish to charge
@property (nonatomic, copy) NSArray<ARPaymentSummaryItem *> *paymentSummaryItems;

@property (nonatomic) UIEdgeInsets insetsForSummaryItems;
@property (nonatomic) CGFloat minimumItemSpacing;
@property (nonatomic) CGFloat spacingToLastItem;

@end
