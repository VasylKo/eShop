//
//  Helper.m
//  eShop
//
//  Created by Vasyl Kotsiuba on 11/6/15.
//  Copyright © 2015 Vasyl Koysiuba. All rights reserved.
//

#import "Helper.h"

//static NSMutableArray *popupStorage; //Of UILabels

//@interface Helper ()
//@property (nonatomic, strong) NSMutableArray *popupStorage; //Of UILabels
//@end

@implementation Helper

#pragma mark - Localized currency
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



#pragma mark - Popup
+ (void)showPopupWithMesssage:(NSString *)message
{
    if ([message isEqualToString:@""]) {
        NSLog(@"Can't show popup with no text");
        return;
    }
    
    //Helper *sharedHelper = [self sharedHelper];
    
    //Create popup label
    UILabel *popupLabel = [self createLabelWithText:message];
    [self.popupStorage addObject:popupLabel];
    
    //Get keyWindos
    UIWindow *appKeyWindow = [[UIApplication sharedApplication] keyWindow];
    
    //Set popup position on screen
    [self calculatePopupPosition];
    
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

//We neew uniq array to store and manage in right way all popups in order to be able to show more than one popup at time by class method showPopupWithMesssage:
+ (NSMutableArray *)popupStorage {
    static NSMutableArray *statArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        statArray = [NSMutableArray array];
    });
    return statArray;
}

+ (void)dismissPopup:(UILabel *)popup {
    
    // Fade out the message and destroy popup
    [UIView animateWithDuration:0.3
                     animations:^  {
                         popup.transform = CGAffineTransformMakeScale(1.3, 1.3);
                         popup.alpha = 0; }
                     completion:^ (BOOL finished) {
                         [self.popupStorage removeObject:popup];
                         [popup removeFromSuperview];
                     }];
}

+ (void)calculatePopupPosition
{
 
    //Get keyWindos
    UIWindow *appKeyWindow = [[UIApplication sharedApplication] keyWindow];
    CGPoint appWindowCenter = appKeyWindow.center;
    
    
    //calculate initial vertical offset
    appWindowCenter.y = appKeyWindow.center.y - (POPUP_HEIGHT / 2 + POPUPS_VERTICAL_OFFSET) * (self.popupStorage.count - 1);
    
    for (int i = 0; i < self.popupStorage.count; i++) {
        UILabel *popup = self.popupStorage[i];
        
        //don't animate last popup
        if ((i + 1) != self.popupStorage.count) {
            [UIView animateWithDuration:0.3 animations:^{
                popup.center = appWindowCenter;
            }];
        
        } else {
            popup.center = appWindowCenter;
        }
        
        //place next popup lower
        appWindowCenter.y += POPUP_HEIGHT + POPUPS_VERTICAL_OFFSET;
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
