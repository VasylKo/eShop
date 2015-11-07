//
//  ItemDetailsTableViewController.h
//  eShop
//
//  Created by Vasyl Kotsiuba on 11/7/15.
//  Copyright © 2015 Vasyl Koysiuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

typedef NS_ENUM (NSUInteger, ItemDetailsViewControllerMode) {
    ItemDetailsViewControllerModeAddItem,
    ItemDetailsViewControllerModeBuyItem,
    ItemDetailsViewControllerModeEditItem
};

@interface ItemDetailsTableViewController : UITableViewController
@property (nonatomic, strong) Item *item;
@property (nonatomic) ItemDetailsViewControllerMode itemDetailsViewControllerMode;

@end
