//
//  Helper.m
//  eShop
//
//  Created by Vasyl Kotsiuba on 11/6/15.
//  Copyright © 2015 Vasyl Koysiuba. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+ (NSString *)currencyFormatter:(NSString *)givenString {
    
    NSString *result = @"";
    
    //If the string is not a valid number, then number will be nil
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *number = [numberFormatter numberFromString:givenString];
    
    if (number) {
        NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
        [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [currencyFormatter setMaximumFractionDigits:0];
        result = [currencyFormatter stringFromNumber:number];
    }
   
    return result;
}


@end
