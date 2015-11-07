//
//  ItemDetailsTableViewController.m
//  eShop
//
//  Created by Vasyl Kotsiuba on 11/7/15.
//  Copyright © 2015 Vasyl Koysiuba. All rights reserved.
//

#import "ItemDetailsTableViewController.h"
#import "Helper.h"

@interface ItemDetailsTableViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *butItemButton;
@property (weak, nonatomic) IBOutlet UITextView *itemNameTextView;
@property (weak, nonatomic) IBOutlet UITextView *itemDescriptionTextView;
@property (weak, nonatomic) IBOutlet UITextView *itemPriceTextView;

@end

@implementation ItemDetailsTableViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.item) {
        [self prepareViewControllerForBuyItemMode];
    } else {
        [self prepareViewControllerForAddItemMode];
    }
    
    //Set gesture recognizer (handle tap to hide keyboard)
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpinside:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    
}

#pragma mark - Initial setup
- (void)prepareViewControllerForBuyItemMode{
    
    self.navigationItem.rightBarButtonItem = nil;
    self.title = self.item ? self.item.itemName : @"Товар";
    
    //Get items details
    self.itemNameTextView.text = self.item.itemName;
    self.itemDescriptionTextView.text = self.item.itemDescription;
    self.itemPriceTextView.text = self.item.itemPrice;
    
    self.itemNameTextView.editable = NO;
    self.itemDescriptionTextView.editable = NO;
    self.itemPriceTextView.editable = NO;
    
}

- (void)prepareViewControllerForAddItemMode {
    self.itemNameTextView.text = @"";
    self.itemDescriptionTextView.text = @"";
    self.itemPriceTextView.text = @"";
   
    self.butItemButton.hidden = YES;
}

#pragma mark - Handle touch
- (void)touchUpinside:(UITapGestureRecognizer *)sender
{
    //Resign first responder
    [self.view endEditing:YES];
}

#pragma mark - Actions
- (IBAction)buyItemButtonPressed:(UIButton *)sender {
    if (self.item) {
        NSLog(@"Buy %@", self.item.itemName);
    }
}
- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    if ([self isTextFilled]) {
        [self addItemToShop];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [Helper showOKAlertWithTitle:@"Ошибка" andMessage:@"Пожалуйста, заполните всю информацию о товаре" inViewController:self];
    }
    
}

#pragma mark - Add item
- (void)addItemToShop {
    [self.view endEditing:YES];
}

#pragma mark - Text view delegate

- (BOOL) textView: (UITextView*) textView
shouldChangeTextInRange: (NSRange) range
  replacementText: (NSString*) text
{
    //Prevent entering letters to price text view
    if (textView == self.itemPriceTextView) {
        return  [self isPriceStringValid:text] ? YES : NO;
    }
    
    return YES;
}

#pragma mark - Helper methods
- (BOOL)isTextFilled {
    if (self.itemNameTextView.text.length > 0 &&
        self.itemDescriptionTextView.text > 0 &&
        self.itemPriceTextView.text.length > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isPriceStringValid:(NSString *)string
{
    NSRange inRange;
    NSCharacterSet *allowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    inRange = [string rangeOfCharacterFromSet:allowedChars];
    
    return inRange.location != NSNotFound ? NO : YES;
}

@end
