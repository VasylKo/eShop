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

@interface ShopManager : NSObject
@property (nonatomic, strong, readonly) NSArray *shopItems;

//Singleton
+ (instancetype)sharedManager;

- (void)loadShopDataInBackground:(void (^)(BOOL success))completionHandler; //Array of Item objects
- (void)addItemToShop:(Item *)item withCompletionHandler:(void (^)(BOOL success))completionHandler;

@end
