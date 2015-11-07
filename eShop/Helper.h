//
//  Helper.h
//  eShop
//
//  Created by Vasyl Kotsiuba on 11/6/15.
//  Copyright © 2015 Vasyl Koysiuba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Helper : NSObject

#define SHOP_ITEM_REUSABLE_IDENTIFIER @"shopItem"
#define SHOP_ITEMS_TABLE_ROW_HIEGHT 50.0
#define SHOP_REFRESH_TIME 2.0
#define BUY_ITEM_TIME 3.0
#define ADD_ITEM_TIME 5.0

//Data model keys
#define ITEM_NAME_KEY @"name"
#define ITEM_DESCRIPTION_KEY @"description"
#define ITEM_PRICE_KEY @"price"

//Tags of Views on shop prototype cell
#define ITEM_NAME_LABEL_TAG 1000
#define ITEM_PRICE_LABEL_TAG 1001
#define BUY_NOW_BUTTON_TAG 1002

//Segue identifiers
#define SHOW_ITEM_DETAILS_SEGUE_IDENTIFIER @"showItemDetails"

//Convert NSString with number into localaized currency formatted string 
+ (NSString *)currencyFormatter:(NSString *)givenString;

//Show alert with OK button
+ (void)showOKAlertWithTitle:(NSString *)title andMessage:(NSString *)message inViewController:(UIViewController *)vc;

@end
