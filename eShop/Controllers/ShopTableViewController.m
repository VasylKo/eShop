//
//  ShopTableViewController.m
//  eShop
//
//  Created by Vasyl Kotsiuba on 11/6/15.
//  Copyright © 2015 Vasyl Koysiuba. All rights reserved.
//

#import "ShopTableViewController.h"
#import "Helper.h"
#import "ShopManager.h"
#import "Item.h"
#import "ItemDetailsTableViewController.h"

@interface ShopTableViewController ()
@property (nonatomic,strong) ShopManager *shopManager;
@property (nonatomic, strong) NSArray *shopItems; //Of Item objects
@property (weak, nonatomic) IBOutlet UIRefreshControl *tableRefreshControl;
@property (nonatomic, strong) Item *currentlySelectedItem;

@end

@implementation ShopTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shopManager = [ShopManager sharedManager];
    [self refreshShopData];
    
    //Listen for notifications from shop namger
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                         selector:@selector(newItemAddedToShopNotification:)
                             name:kItemAddedToShopNotification
                           object:self.shopManager];
    
    [notificationCenter addObserver:self
                           selector:@selector(itemPurchasedNotification:)
                               name:kItemPurchasedToShopNotification
                             object:self.shopManager];
}

#pragma mark - Interaction with shop manager
- (void)refreshShopData {
    [self.refreshControl beginRefreshing];
    
    [self.shopManager loadShopDataInBackground:^(BOOL finished) {
        
        //Make UI updates in main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finished) {
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
            }
        });
      
        
    }];
}

- (void)newItemAddedToShopNotification:(NSNotification *)notification{
    NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:self.shopItems.count - 1 inSection:0];
    
    [self.tableView insertRowsAtIndexPaths:@[insertIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    NSString *itemName = notification.userInfo[ITEM_NAME_KEY];
    NSString *message = [NSString stringWithFormat:@"%@\nТовар добавлен!", itemName];
    [Helper showPopupWithMesssage:message];
}

- (void)itemPurchasedNotification:(NSNotification *)notification{
    
    NSString *itemName = notification.userInfo[ITEM_NAME_KEY];
    NSString *message = [NSString stringWithFormat:@"Вы купили %@\nСпасибо за покупку!", itemName];
    [Helper showPopupWithMesssage:message];
}

- (NSArray *)shopItems {
    return self.shopManager.shopItems;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.shopItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SHOP_ITEM_REUSABLE_IDENTIFIER forIndexPath:indexPath];
    
    //Get item object
    Item *item = self.shopItems[indexPath.row];
    
    //Configure the cell
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:ITEM_NAME_LABEL_TAG];
    nameLabel.text = item.itemName;
    
    UILabel *priceLabel = (UILabel *)[cell viewWithTag:ITEM_PRICE_LABEL_TAG];
    priceLabel.text = [Helper currencyFormatter:item.itemPrice];
    
    UIButton *buyNowButton = (UIButton *)[cell viewWithTag:BUY_NOW_BUTTON_TAG];
    [buyNowButton addTarget:self action:@selector(buyNowButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SHOP_ITEMS_TABLE_ROW_HIEGHT;
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:SHOW_ITEM_DETAILS_SEGUE_IDENTIFIER]) {
        //Get currently selected Item to be passed to Item details VC
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Item *currentlySelectedItem = self.shopItems[indexPath.row];
        
        ItemDetailsTableViewController *itemDetailsVC = segue.destinationViewController;
        itemDetailsVC.item = currentlySelectedItem;
    }
}


#pragma mark - Actions
- (IBAction)refreshTableTriggered:(UIRefreshControl *)refresh {
    [self refreshShopData];
}

- (void)buyNowButtonPressed:(UIButton *)button
{
    //Get TableViewCell. First button super view is UITableViewCellContentView. Second should be UITableViewCell
    id clickedCell = [[button superview] superview];
    
    //Check if we retrieve UITableViewCell
    if ([clickedCell isMemberOfClass:[UITableViewCell class]]) {
        NSIndexPath *clickedButtonPath = [self.tableView indexPathForCell:clickedCell];
        NSLog(@"Section: %d, Row: %d", clickedButtonPath.section, clickedButtonPath.row);
    }
}

#pragma mark - Dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
