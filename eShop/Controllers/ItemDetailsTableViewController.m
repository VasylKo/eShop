//
//  ItemDetailsTableViewController.m
//  eShop
//
//  Created by Vasyl Kotsiuba on 11/7/15.
//  Copyright © 2015 Vasyl Koysiuba. All rights reserved.
//

#import "ItemDetailsTableViewController.h"

@interface ItemDetailsTableViewController ()
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
    
    
}

- (void)viewDidLayoutSubviews {
    //To scroll text view contetn to top
//    [self.itemNameTextView setContentOffset:CGPointZero animated:YES];
//    [self.itemDescriptionTextView setContentOffset:CGPointZero animated:YES];
//    [self.itemPriceTextView setContentOffset:CGPointZero animated:YES];
}

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

#pragma mark - Actions
- (IBAction)buyItemButtonPressed:(UIButton *)sender {
}
- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
