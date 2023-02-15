//
//  ContactsTableViewController.m
//  scanCardProject
//
//  Created by 胡淨淳 on 2021/10/18.
//  Copyright © 2021 JXInfo. All rights reserved.
//

#import "ContactsTableViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface ContactsTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *itemArray;
@property (strong, nonatomic) NSArray *results;

@property (strong,nonatomic) UITableView *tableView;

@end

@implementation ContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"entring contact pageeee");
    
    [self configureTableview];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self loadContacts];
}


-(void)configureTableview {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

}

#pragma  mark - Loading contacts

-(void)loadContacts {
    
    self.itemArray = [NSMutableArray array];
    
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"CustomerItem"];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    _results = [context executeFetchRequest:request error:&error];
    
    if (_results == nil) {
        NSLog(@"Error fetching: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
        
    } else {
        NSLog(@"dataaaaa %@", _results);
        
        for (NSData *attribute in [_results valueForKey:@"name"]) {
            if (attribute) {
                NSArray *nameItemArray = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray self] fromData:attribute error:&error];
                
                for (id items in nameItemArray) {
                    [_itemArray addObject:items];
                    NSLog(@"itemArray : %@", items);
                }
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSLog(@"itemArray count: %lu", (unsigned long)_itemArray.count);
    return _itemArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showContactDetailsSegue" sender:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"contactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = _itemArray[indexPath.row];
    
    return  cell;
}


@end
