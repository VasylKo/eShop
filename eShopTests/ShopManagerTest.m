//
//  ShopManagerTest.m
//  eShop
//
//  Created by Vasyl Kotsiuba on 11/7/15.
//  Copyright © 2015 Vasyl Koysiuba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ShopManager.h"
#import "Item.h"

@interface ShopManagerTest : XCTestCase
@property (nonatomic, strong) ShopManager *shopManager;
@end

@implementation ShopManagerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.shopManager = [ShopManager sharedManager];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testShopItems {
    XCTAssertNotNil(self.shopManager.shopItems, "Items list should not be nil");
    
    //Asynchronous test
    XCTestExpectation *expectation = [self expectationWithDescription:@"Items list loading"];
    
    [self.shopManager loadShopDataInBackground:^(BOOL finished) {
        
        XCTAssert(self.shopManager.shopItems.count > 0, "No items loaded");
        
        //Check if array containt Item objects
        for (id item in self.shopManager.shopItems) {
            XCTAssert([item isKindOfClass:[Item class]], "Array contain non Item objects");
        }
        
        //Fulfill expectation
        [expectation fulfill];
    }];
    
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error, "Check for error");
    }];
    
    
}


@end
