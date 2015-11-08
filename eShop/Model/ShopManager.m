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

NSString *const kItemAddedToShopNotification = @"itemAddedToShopNotification";

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
- (void)loadShopDataInBackground:(void (^)(BOOL success))completionHandler {
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        #warning Test delay to show that data is loading in backgroung
        [NSThread sleepForTimeInterval:SHOP_REFRESH_TIME];
        [self loadShopDataFromPlist];
        
        completionHandler(YES);
    });
    
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

- (void)addItemToShop:(Item *)item withCompletionHandler:(void (^)(BOOL success))completionHandler {
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        #warning Test delay to emutale time nedeed to add item to shop
        [NSThread sleepForTimeInterval:ADD_ITEM_TIME];
        
        NSArray *addedItems = [NSArray new];
        NSString *JSONFilePath = [self JSONFileLocation];
        
        if ([self fileExistsAtPath:JSONFilePath]) {
            addedItems = [self loadJSONDataToArray];
        }
        
        //Parse item
        NSDictionary *itemDic = [self parseItemToDictionary:item];
        
        //Add parsed item to array
        addedItems = [addedItems arrayByAddingObject:itemDic];
        
        //Write array to disk
        BOOL isSavedToDisk = [self saveArrayAsJSON:addedItems toPath:JSONFilePath];
        
        //add item to current shop manager
        [self addItemsToShop:@[item]];
        
        //Post notification on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kItemAddedToShopNotification
                                                                object:self
                                                              userInfo:@{ITEM_NAME_KEY : item.itemName}];
        });
        
        completionHandler(isSavedToDisk);
    });
    
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

- (NSDictionary *)parseItemToDictionary:(Item *)item {
    
    //Read item properties
    NSString *itemName = item.itemName ? item.itemName : @"";
    NSString *itemDescription = item.itemDescription ? item.itemDescription : @"";
    NSString *itemPrice = item.itemPrice ? item.itemPrice : @"";
    
    //Create dictionary
    NSDictionary *dic = @{ITEM_NAME_KEY : itemName, ITEM_DESCRIPTION_KEY : itemDescription, ITEM_PRICE_KEY : itemPrice};
    
    return dic;
}

- (BOOL)fileExistsAtPath:(NSString *)filePath{
    
    BOOL result = NO;
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:filePath]){
        result = YES;
    }
    
    return result;
}

- (NSString *)JSONFileLocation{
    
    //Get the document folder(s)
    NSArray *folders =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    
    if ([folders count] == 0){
        return nil;
    }
    
    // Get the first folder path
    NSString *documentsFolder = folders[0];
    
    // Append the filename to the end of the documents path
    return [documentsFolder
            stringByAppendingPathComponent:@"data.json"];
    
}

- (BOOL)saveArrayAsJSON:(NSArray *)array toPath:(NSString *)filePath {
    
    BOOL result = NO;
    //Serialize JSON
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    
    if (!error) {
        //Write safety to file
        result = [jsonData writeToFile:filePath atomically:YES];
    } else {
        NSLog(@"ERROR! Can't serialize JSON:%@", [error localizedDescription]);
    }
    
    return result;
}

- (NSArray *)loadJSONDataToArray {
    
    NSArray *result = nil;
    
    NSData *jsonData = [NSData dataWithContentsOfFile:[self JSONFileLocation]];
    
    //Parse JSON
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    //check for error
    if (!error) {
        if ([jsonObject isKindOfClass:[NSArray class]]) {
            result = (NSArray *)jsonObject;
        }
    } else {
        NSLog(@"ERROR! Can't read JSON data:%@", [error localizedDescription]);
    }
    
    return result;
}

@end
