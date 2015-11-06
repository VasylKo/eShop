//
//  ShopItems.h
//  eShop
//
//  Created by Vasyl Kotsiuba on 11/6/15.
//  Copyright © 2015 Vasyl Koysiuba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopManager : NSObject
@property (nonatomic, strong, readonly) NSArray *shopItems;

//Singleton
+ (instancetype)sharedManager;

- (void)loadShopDataInBackground:(void (^)(NSArray *shopItems))completionHandler; //Array of Item objects

@end
