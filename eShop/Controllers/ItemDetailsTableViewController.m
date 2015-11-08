//
//  ItemDetailsTableViewController.m
//  eShop
//
//  Created by Vasyl Kotsiuba on 11/7/15.
//  Copyright © 2015 Vasyl Koysiuba. All rights reserved.
//

#import "ItemDetailsTableViewController.h"
#import "ShopManager.h"
#import "Helper.h"

@interface ItemDetailsTableViewController () <UITextViewDelegate>
@property (nonatomic,strong) ShopManager *shopManager;

@property (weak, nonatomic) IBOutlet UIButton *butItemButton;
@property (weak, nonatomic) IBOutlet UITextView *itemNameTextView;
@property (weak, nonatomic) IBOutlet UITextView *itemDescriptionTextView;
@property (weak, nonatomic) IBOutlet UITextView *itemPriceTextView;

@end

@implementation ItemDetailsTableViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.shopManager = [ShopManager sharedManager];
    
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
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                 target:self action:@selector(shareButtonPressed:)];
    self.navigationItem.rightBarButtonItem = shareButton;
    self.title = self.item ? self.item.itemName : @"Товар";
    
    //Get items details
    self.itemNameTextView.text = self.item.itemName;
    self.itemDescriptionTextView.text = self.item.itemDescription;
    self.itemPriceTextView.text = [Helper currencyFormatter:self.item.itemPrice];
    
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
        [self.shopManager purchaseItem:self.item withCompletionHandler:^(BOOL success) {
            
        }];
    }
}
- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    if ([self isTextFilled]) {
        [self addItemToShop];
    } else {
        [Helper showOKAlertWithTitle:@"Ошибка"
                          andMessage:@"Пожалуйста, заполните всю информацию о товаре"];
    }
    
}

- (void)shareButtonPressed:(UIBarButtonItem *)sender {
}

#pragma mark - Add item
- (void)addItemToShop {
    [self.view endEditing:YES];
    
    Item *item = [[Item alloc] initWithName:self.itemNameTextView.text
                                description:self.itemDescriptionTextView.text
                                   andPrice:self.itemPriceTextView.text];
    
    
    [self.shopManager addItemToShop:item withCompletionHandler:^(BOOL success) {
        
        //Make UI updates in main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                /*
                [Helper showOKAlertWithTitle:item.itemName
                                  andMessage:@"Товар добвлен в магазин"];
                 */
            }
            
        });
        
    }];
    
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
