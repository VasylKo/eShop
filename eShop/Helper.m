//
//  Helper.m
//  eShop
//
//  Created by Vasyl Kotsiuba on 11/6/15.
//  Copyright © 2015 Vasyl Koysiuba. All rights reserved.
//

#import "Helper.h"

@interface Helper ()
@property (nonatomic, strong) NSMutableArray *popupLabels; //Of UILabels
@end

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


#pragma mark - Show alert
+ (void)showOKAlertWithTitle:(nullable NSString *)title andMessage:(nullable NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okActin = [UIAlertAction actionWithTitle:@"OK"
                                                      style:UIAlertActionStyleDefault
                                                    handler:nil];
    
    [alertController addAction:okActin];
    
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Singleton
//To make popup methods work properly
+ (instancetype)sharedHelper
{
    
    static Helper *sharedHelper = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedHelper = [[Helper alloc] init];
        
        if (sharedHelper) {
            sharedHelper.popupLabels = [[NSMutableArray alloc] init];
        }
    });
    
    return sharedHelper;
    
}

#pragma mark - Popup
#define POPUP_DELAY 1.5
#define POPUP_HEIGHT 50
#define POPUP_WIDTH 250
#define POPUP_VERTICAL_OFFSET 10
+ (void)showPopupWithMesssage:(NSString *)message
{
    if ([message isEqualToString:@""]) {
        NSLog(@"Can't show popup with no text");
        return;
    }
    
    Helper *sharedHelper = [self sharedHelper];
    
    //Create popup label
    UILabel *popupLabel = [self createLabelWithText:message];
    [sharedHelper.popupLabels addObject:popupLabel];
    
    //Get keyWindos
    UIWindow *appKeyWindow = [[UIApplication sharedApplication] keyWindow];
    
    //Set popup position on screen
    [sharedHelper calculatePopupPosition];
    
    //show popup
    [appKeyWindow addSubview:popupLabel];
    popupLabel.transform = CGAffineTransformMakeScale(1.3, 1.3);
    popupLabel.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        popupLabel.alpha = 1;
        popupLabel.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
    //Dismiss popup after delay
    [self performSelector:@selector(dismissPopup:) withObject:popupLabel afterDelay:POPUP_DELAY];
}

+ (void)dismissPopup:(UILabel *)popup {
    
    Helper *sharedHelper = [self sharedHelper];

    // Fade out the message and destroy popup
    [UIView animateWithDuration:0.3
                     animations:^  {
                         popup.transform = CGAffineTransformMakeScale(1.3, 1.3);
                         popup.alpha = 0; }
                     completion:^ (BOOL finished) {
                         [[sharedHelper popupLabels] removeObject:popup];
                         [popup removeFromSuperview];
                     }];
}

- (void)calculatePopupPosition
{
 
    //Get keyWindos
    UIWindow *appKeyWindow = [[UIApplication sharedApplication] keyWindow];
    CGPoint appWindowCenter = appKeyWindow.center;
    
    NSMutableArray *popups = [self popupLabels];
    
    //calculate initial vertical offset
    appWindowCenter.y = appKeyWindow.center.y - (POPUP_HEIGHT / 2 + POPUP_VERTICAL_OFFSET) * (popups.count - 1);
    
    for (int i = 0; i < popups.count; i++) {
        UILabel *popup = popups[i];
        
        //don't animate last object
        if (![popup isEqual:popups.lastObject]) {
            [UIView animateWithDuration:0.3 animations:^{
                popup.center = appWindowCenter;
            }];
        
        } else {
            popup.center = appWindowCenter;
        }
        
        //place next popup lower
        appWindowCenter.y += POPUP_HEIGHT + POPUP_VERTICAL_OFFSET;
    }
}

+ (UILabel *)createLabelWithText:(NSString *)message
{
    UILabel *popupLabel = [[UILabel alloc] init];
    //Set text
    popupLabel.text = message;
    
    popupLabel.textAlignment = NSTextAlignmentCenter;
    popupLabel.numberOfLines = 2;
    
    //Set frame
    CGFloat textWidth = popupLabel.intrinsicContentSize.width;
    CGRect labelFrame = CGRectMake(0, 0, textWidth + 20, POPUP_HEIGHT);
    
    //To make popup not to be wider tan POPUP_WIDTH points
    if (textWidth > POPUP_WIDTH) {
        labelFrame = [popupLabel textRectForBounds:CGRectMake(0, 0, POPUP_WIDTH, POPUP_HEIGHT)
                            limitedToNumberOfLines:2];
    }
    
    popupLabel.frame = labelFrame;
    
    //Set color
    popupLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
    popupLabel.textColor = [UIColor whiteColor];
    
    //Make rounded rect
    popupLabel.layer.cornerRadius = 5.0;
    popupLabel.clipsToBounds=YES;
    
    return popupLabel;
}

@end
