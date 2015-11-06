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

@interface ShopTableViewController ()
@property (nonatomic,strong) ShopManager *shopManager;
@property (nonatomic, strong) NSArray *shopItems; //Of Item objects
@property (weak, nonatomic) IBOutlet UIRefreshControl *tableRefreshControl;

@end

@implementation ShopTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.refreshControl beginRefreshing];
    self.shopManager = [ShopManager sharedManager];
    [self.shopManager loadShopDataInBackground:^(NSArray *shopItems) {
        NSLog(@"Yes");
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Accessors
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
    
    UILabel *descriptionLabel = (UILabel *)[cell viewWithTag:ITEM_DESCRIPTION_LABEL_TAG];
    descriptionLabel.text = item.itemDescription;
    
    UIButton *buyNowButton = (UIButton *)[cell viewWithTag:1003];
    [buyNowButton addTarget:self action:@selector(buyNowButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

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
- (IBAction)refreshTableTriggered:(UIRefreshControl *)refresh {
    [self.shopManager loadShopDataInBackground:^(NSArray *shopItems) {
        [self.tableView reloadData];
        [refresh endRefreshing];
        
    }];
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

@end
