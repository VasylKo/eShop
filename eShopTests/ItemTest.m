//
//  eShopTests.m
//  eShopTests
//
//  Created by Vasyl Kotsiuba on 11/7/15.
//  Copyright © 2015 Vasyl Koysiuba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Item.h"

@interface ItemTest : XCTestCase
@property (nonatomic, strong) Item *item;
@end

@implementation ItemTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.item = [[Item alloc] init];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testItemName {
    self.item.itemName = @"iWatch";
    
    XCTAssertNotNil(self.item.itemName, "Name should not be nil");
    XCTAssertEqual(self.item.itemName, @"iWatch", "Item name don't match test name");
    
    self.item.itemName = nil;
    XCTAssertNotNil(self.item.itemName, "Name should not be nil");
}

- (void)testItemDescription {
    self.item.itemDescription = @"42mm";
    
    XCTAssertNotNil(self.item.itemDescription, "Description should not be nil");
    XCTAssertEqual(self.item.itemDescription, @"42mm", "Item description don't match test description");
    
    self.item.itemDescription = nil;
    XCTAssertNotNil(self.item.itemDescription, "Description should not be nil");
}

- (void)testItemPrice {
    self.item.itemPrice = @"250";
    
    XCTAssertNotNil(self.item.itemPrice, "Price should not be nil");
    XCTAssertEqual(self.item.itemPrice, @"250", "Item price don't match test price");
    
    self.item.itemName = nil;
    XCTAssertNotNil(self.item.itemPrice, "Price should not be nil");
}


@end
