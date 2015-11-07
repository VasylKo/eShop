//
//  Item.m
//  eShop
//
//  Created by Vasyl Kotsiuba on 11/6/15.
//  Copyright © 2015 Vasyl Koysiuba. All rights reserved.
//

#import "Item.h"
#import "Helper.h"

@implementation Item

- (instancetype)initWithName:(NSString *)name description:(NSString *)description andPrice:(NSString *)price {
    self = [super init];
    
    if (self) {
        _itemName = name;
        _itemDescription = description;
        _itemPrice = price;
    }
    
    return self;
}

- (void)setItemName:(NSString *)itemName {
    
    if (!itemName || [itemName isEqualToString:@""]) {
        itemName = @"No name";
    }
    
    _itemName = itemName;
}

- (void)setItemPrice:(NSString *)itemPrice {
    if (!itemPrice || [itemPrice isEqualToString:@""]) {
        itemPrice = @"0";
    }
    
    _itemPrice = itemPrice;
}

- (void)setItemDescription:(NSString *)itemDescription {
    if (!itemDescription || [itemDescription isEqualToString:@""]) {
        itemDescription = @"No description";
    }
    
    _itemDescription = itemDescription;
}

@end
