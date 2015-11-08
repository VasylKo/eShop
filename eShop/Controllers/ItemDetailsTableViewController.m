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
#import <CoreText/CoreText.h>
#import <MessageUI/MessageUI.h>

@interface ItemDetailsTableViewController () <UITextViewDelegate, MFMailComposeViewControllerDelegate>
@property (nonatomic,strong) ShopManager *shopManager;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *buyItemActivityIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *addItemActivityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *buyItemButton;
@property (weak, nonatomic) IBOutlet UITextView *itemNameTextView;
@property (weak, nonatomic) IBOutlet UITextView *itemDescriptionTextView;
@property (weak, nonatomic) IBOutlet UITextView *itemPriceTextView;
@property (strong, nonatomic) IBOutlet UIView *pdfView;
@property (weak, nonatomic) IBOutlet UILabel *pdfItemName;
@property (weak, nonatomic) IBOutlet UILabel *pdfItemDescription;
@property (weak, nonatomic) IBOutlet UILabel *pdfItemPrice;


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
    
    self.buyItemActivityIndicator.hidden = YES;
    
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
    [self clearTextViews];
   
    self.buyItemButton.hidden = YES;
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)clearTextViews {
    self.itemNameTextView.text = @"";
    self.itemDescriptionTextView.text = @"";
    self.itemPriceTextView.text = @"";
}

#pragma mark - Handle touch
- (void)touchUpinside:(UITapGestureRecognizer *)sender
{
    //Resign first responder
    [self.view endEditing:YES];
}

#pragma mark - Actions
- (IBAction)buyItemButtonPressed:(UIButton *)sender {
    self.buyItemActivityIndicator.hidden = NO;
    self.buyItemButton.enabled = NO;
    [self.buyItemActivityIndicator startAnimating];
    if (self.item) {
        [self.shopManager purchaseItem:self.item withCompletionHandler:^(BOOL success) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.buyItemActivityIndicator stopAnimating];
                self.buyItemActivityIndicator.hidden = YES;
                self.buyItemButton.enabled = YES;
            });
            
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
    [self createPDF];
    [self sendPDFOverMail];
}

#pragma mark - Add item
- (void)addItemToShop {
    [self.view endEditing:YES];
    
    Item *item = [[Item alloc] initWithName:self.itemNameTextView.text
                                description:self.itemDescriptionTextView.text
                                   andPrice:self.itemPriceTextView.text];
    
    //add activity indicator
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.backgroundColor = [UIColor lightGrayColor];
    activityView.layer.cornerRadius = 3.0;
    UIBarButtonItem *batButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityView];
    self.navigationItem.leftBarButtonItem = batButtonItem;
    [activityView startAnimating];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self clearTextViews];
    
    ItemDetailsTableViewController * __weak weakSelf = self;
    [self.shopManager addItemToShop:item withCompletionHandler:^(BOOL success) {
        
        //Make UI updates in main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
            [activityView stopAnimating];
            weakSelf.navigationItem.leftBarButtonItem = batButtonItem;
            
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

#pragma mark - PDF
//Generate a PDF using UIKit
-(void)createPDF {
    
    NSString* pdfFileLocation = [self PDFFileLocation];
    
    [[NSBundle mainBundle] loadNibNamed:@"PDFView" owner:self options:nil];
    
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(pdfFileLocation, CGRectZero, nil);
    CGContextRef pdfContext=UIGraphicsGetCurrentContext();
    
    UIGraphicsBeginPDFPage();
    
    //Update the UI elements on view
    self.pdfItemName.text = self.item.itemName;
    self.pdfItemDescription.text = self.item.itemDescription;
    self.pdfItemPrice.text = [Helper currencyFormatter:self.item.itemPrice];
    
    [self.pdfView layoutIfNeeded];
    
    //Rander view's layer to pdf
    [self.pdfView.layer renderInContext:pdfContext];
    
    // finally end the PDF context.
    UIGraphicsEndPDFContext();
}

- (NSString *)PDFFileLocation{
    
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
            stringByAppendingPathComponent:@"item.PDF"];
    
}

- (void)sendPDFOverMail {
    NSData *pdfData = [NSData dataWithContentsOfFile:[self PDFFileLocation]];
    
    MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
    mailComposeViewController.mailComposeDelegate = self;
    
    //Configurate mail
    [mailComposeViewController setSubject:self.item.itemName];
    [mailComposeViewController setMessageBody:@"Посмотрите товар с нашего магазина."
                                       isHTML:NO];
    [mailComposeViewController addAttachmentData:pdfData
                                        mimeType:@"application/pdf"
                                        fileName:[NSString stringWithFormat:@"Item.pdf"]];
    
    [self presentViewController:mailComposeViewController animated:YES completion:nil];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MFMailComposeResultSent) {
        NSLog(@"PDF sent");
    } else {
        NSLog(@"PDF send error %@",[error localizedDescription]);
    }
}

@end
