//
//  ShopItems.m
//  eShop
//
//  Created by Vasyl Kotsiuba on 11/6/15.
//  Copyright © 2015 Vasyl Koysiuba. All rights reserved.
//

#import "ShopManager.h"
#import "Item.h"
#import "Helper.h"

@interface ShopManager ()
@property (nonatomic, strong, readwrite) NSArray *shopItems;

@end

@implementation ShopManager
#pragma mark - Singleton
+ (instancetype)sharedManager
{
    static ShopManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[ShopManager alloc] init];
        
        if (sharedManager) {
            
            //Create new shop items list
            sharedManager.shopItems = [NSArray new];
        
        }
        
    });
    
    return sharedManager;
}

#pragma mark - Shop manager
- (void)loadShopDataInBackground:(void (^)(NSArray *shopItems))completionHandler {
    
    [self loadShopDataFromPlist];
    completionHandler(self.shopItems);
}

- (void)loadShopDataFromPlist {
    
    NSString *plistFilePath = [self initialShopItmesPlistPath];
    
    //Check if file exists at given path
    if (plistFilePath) {
        //Load data to array
        NSArray *itemsFromPlist = [NSArray arrayWithContentsOfFile:plistFilePath];
        
        //Parse array
        NSArray *items = [self parseItemsFromDataArray:itemsFromPlist];
        
        //Add items to shop
        [self addItemsToShop:items];
    }
}

//Add Item objects to shop list
- (void)addItemsToShop:(NSArray *)items {
    
    if (items.count) {
        //Check if items are of Item type and app them to the shop list
        for (NSObject *object in items) {
            if ([object isKindOfClass:[Item class]]) {
                self.shopItems = [self.shopItems arrayByAddingObject:object];
            }
        }
    }
}

#pragma mark - Hepler methods
- (NSString *)initialShopItmesPlistPath{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"InitialShopItems" ofType:@"plist"];
    
    if (!filePath) {
        NSLog(@"ERROR! No plist file found!");
    }
    
    return filePath;
}

//Returns array of Item objects
- (NSArray *)parseItemsFromDataArray:(NSArray *)itemsData {
    
    NSMutableArray *items = [NSMutableArray new]; //Of Item objects
    
    //Fill items from loaded data
    for (NSDictionary *dic in itemsData) {
        Item *item = [[Item alloc] init];
        
        item.itemName = dic[ITEM_NAME_KEY];
        item.itemDescription = dic[ITEM_DESCRIPTION_KEY];
        item.itemPrice = dic[ITEM_PRICE_KEY];
        
        [items addObject:item];
    }
    
    return [items copy];
}


@end
