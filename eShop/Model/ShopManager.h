//
//  ShopItems.h
//  eShop
//
//  Created by Vasyl Kotsiuba on 11/6/15.
//  Copyright © 2015 Vasyl Koysiuba. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Item;

extern NSString *const kItemAddedToShopNotification;
extern NSString *const kItemPurchasedToShopNotification;

@interface ShopManager : NSObject
@property (nonatomic, strong, readonly) NSArray *shopItems; //Of Item objects

//Singleton
+ (instancetype)sharedManager;

- (void)loadShopDataInBackground:(void (^)(BOOL finished))completionHandler;
- (void)addItemToShop:(Item *)item withCompletionHandler:(void (^)(BOOL success))completionHandler;
- (void)purchaseItem:(Item *)item withCompletionHandler:(void (^)(BOOL success))completionHandler;

@end
