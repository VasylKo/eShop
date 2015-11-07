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
@property (nonatomic, strong) UIBarButtonItem *cancelBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *doneBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *cartButton;

@property (weak, nonatomic) IBOutlet UIButton *butItemButton;
@property (weak, nonatomic) IBOutlet UITextView *itemNameTextView;
@property (weak, nonatomic) IBOutlet UITextView *itemDescriptionTextView;
@property (weak, nonatomic) IBOutlet UITextView *itemPriceTextView;
@property (nonatomic) BOOL enableEditing;

@end

@implementation ItemDetailsTableViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Create bar button items
    self.cancelBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                             target:self
                                                                             action:@selector(cancelButtonPressed:)];
    
    self.doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                           target:self
                                                                           action:@selector(doneButtonPressed:)];
    UIImage *emptyCartImage = [UIImage imageNamed:@"emptyCartIcon"];
    self.cartButton = [[UIBarButtonItem alloc] initWithImage:emptyCartImage
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:nil];
    

    [self prepareViewControllerForMode:self.itemDetailsViewControllerMode];
    [self setupTextViews];
    
    //Set gesture recognizer (handle tap to hide keyboard)
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpinside:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    
}

#pragma mark - Initial setup
- (void)prepareViewControllerForMode:(ItemDetailsViewControllerMode)mode
{
    switch (mode) {
        case (ItemDetailsViewControllerModeBuyItem):
            self.navigationItem.rightBarButtonItem = self.cartButton;
            self.enableEditing = NO;
            self.title = self.item ? self.item.itemName : @"Товар";
            break;
            
        case (ItemDetailsViewControllerModeAddItem):
            self.navigationItem.rightBarButtonItem = self.doneBarButtonItem;
            self.navigationItem.leftBarButtonItem = self.cancelBarButtonItem;
            self.enableEditing = YES;
            self.butItemButton.hidden = YES;
            self.title = @"Добавить товар";
            break;
            
        default:
            break;
    }
}

- (void)setupTextViews {
    NSString *itemName = @"";
    NSString *itemDescription = @"";
    NSString *itemPrice = @"";
    
    if (self.item) {
        itemName = self.item.itemName;
        itemDescription = self.item.itemDescription;
        itemPrice = self.item.itemPrice;
    }
    
    self.itemNameTextView.text = itemName;
    self.itemDescriptionTextView.text= itemDescription;
    self.itemPriceTextView.text = itemPrice;
    
    self.itemNameTextView.editable = self.enableEditing;
    self.itemDescriptionTextView.editable = self.enableEditing;
    self.itemPriceTextView.editable = self.enableEditing;
    
    self.itemPriceTextView.keyboardType = UIKeyboardTypeNumberPad;
    
    self.itemNameTextView.delegate = self;
    self.itemDescriptionTextView.delegate= self;
    self.itemPriceTextView.delegate = self;
    
}
#pragma mark - Table view data source



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Handle touch
- (void)touchUpinside:(UITapGestureRecognizer *)sender
{
    //Resign first responder
    [self.view endEditing:YES];
}

#pragma mark - Actions
- (IBAction)buyItemButtonPressed:(UIButton *)sender {
}
- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
    if ([self isTextFilled]) {
        [self saveChangesMadeToItem];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [Helper showOKAlertWithTitle:@"Ошибка" andMessage:@"Пожалуйста, заполните всю информацию о товаре" inViewController:self];
    }
    
}
- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actions
- (void)saveChangesMadeToItem {
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
