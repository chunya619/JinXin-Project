//
//  CustomerDetailsTableViewController.m
//  scanCardProject
//
//  Created by JXInfo on 2021/9/30.
//  Copyright © 2021 JXInfo. All rights reserved.
//

#import "CustomerDetailsTableViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface CustomerDetailsTableViewController () <UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *nameArray;
@property (strong, nonatomic) NSMutableArray *companyArray;
@property (strong, nonatomic) NSMutableArray *departmentArray;
@property (strong, nonatomic) NSMutableArray *titleArray;
@property (strong, nonatomic) NSMutableArray *mobilePhoneArray;
@property (strong, nonatomic) NSMutableArray *workPhoneArray;
@property (strong, nonatomic) NSMutableArray *faxArray;
@property (strong, nonatomic) NSMutableArray *emailArray;
@property (strong, nonatomic) NSMutableArray *addressArray;


@property (strong, nonatomic) NSMutableArray *updateNameArray;
@property (strong, nonatomic) NSMutableArray *updateCompanyArray;
@property (strong, nonatomic) NSMutableArray *updateDepartmentArray;
@property (strong, nonatomic) NSMutableArray *updateTitleArray;
@property (strong, nonatomic) NSMutableArray *updateMobilePhoneArray;
@property (strong, nonatomic) NSMutableArray *updateWorkPhoneArray;
@property (strong, nonatomic) NSMutableArray *updateFaxArray;
@property (strong, nonatomic) NSMutableArray *updateEmailArray;
@property (strong, nonatomic) NSMutableArray *updateAddressArray;

@property (strong, nonatomic) NSMutableArray *selectedDataArray;

@property (strong, nonatomic) NSArray *results;
@property (strong, nonatomic) NSMutableDictionary *listOfCustomerData;


@end

@implementation CustomerDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //keyboard controlling
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    self.tableView.allowsMultipleSelectionDuringEditing = true;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self loadCustomerData];
    
    [self setEditing:YES animated:YES];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}


#pragma mark - Loading all customer data

- (void)loadCustomerData {
    
    self.nameArray = [NSMutableArray array];
    self.companyArray = [NSMutableArray array];
    self.departmentArray = [NSMutableArray array];
    self.titleArray = [NSMutableArray array];
    self.mobilePhoneArray = [NSMutableArray array];
    self.workPhoneArray = [NSMutableArray array];
    self.faxArray = [NSMutableArray array];
    self.emailArray = [NSMutableArray array];
    self.addressArray = [NSMutableArray array];
    
    self.listOfCustomerData = [NSMutableDictionary dictionary];
    
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"CustomerItem"];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    _results = [context executeFetchRequest:request error:&error];
    
    if (_results == nil) {
        NSLog(@"Error fetching: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
        
    } else {
        NSLog(@"all dataaa: %@", _results);
        
        NSArray *nameData = [_results valueForKey:@"name"];
        NSArray *companyData = [_results valueForKey:@"company"];
        NSArray *departmentData = [_results valueForKey:@"department"];
        NSArray *titleData = [_results valueForKey:@"title"];
        NSArray *mobilePhoneData = [_results valueForKey:@"mobilePhone"];
        NSArray *workPhoneData = [_results valueForKey:@"workPhone"];
        NSArray *faxData = [_results valueForKey:@"fax"];
        NSArray *emailData = [_results valueForKey:@"email"];
        NSArray *addressData = [_results valueForKey:@"address"];
        
        for (NSData *data in nameData) {
            NSArray *nameRestoreArray = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class]
                                                    fromData:data error:nil];
            NSLog(@"nameRestoreArray %@", nameRestoreArray);
            for (id name in nameRestoreArray) {
                NSLog(@"item is %@", name);
                for (id item in name) {
                    NSLog(@"name: %@", item);
                    if ([item  isEqual: @""]) {
                        NSLog(@"the name is nil");
                    } else {
                       [_nameArray addObject:item];
                        NSLog(@"nameArray: %@", _nameArray);
                    }
                }
                
            }
        }
        
        for (NSData *data in companyData) {
            NSArray *companyRestoreArray = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class]
                                                    fromData:data error:nil];
            NSLog(@"companyRestoreArray %@", companyRestoreArray);
            for (id company in companyRestoreArray) {
                NSLog(@"item is %@", company);
                for (id item in company) {
                    NSLog(@"company: %@", item);
                    if ([item  isEqual: @""]) {
                        NSLog(@"the company is nil");
                    } else {
                        [_companyArray addObject:item];
                        NSLog(@"companyArray: %@", _companyArray);
                    }
                }
                
            }
        }
        
        for (NSData *data in departmentData) {
            NSArray *departmentRestoreArray = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class]
                                                    fromData:data error:nil];
            NSLog(@"departmentRestoreArray %@", departmentRestoreArray);
            for (id department in departmentRestoreArray) {
                NSLog(@"item is %@", department);
                for (id item in department) {
                    NSLog(@"department: %@", item);
                    if ([item  isEqual: @""]) {
                        NSLog(@"the department is nil");
                    } else {
                        [_departmentArray addObject:item];
                        NSLog(@"departmentArray: %@", _departmentArray);
                    }
                }
                
            }
        }
        
        for (NSData *data in titleData) {
            NSArray *titleRestoreArray = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class]
                                                    fromData:data error:nil];
            NSLog(@"titleRestoreArray %@", titleRestoreArray);
            for (id title in titleRestoreArray) {
                NSLog(@"item is %@", title);
                for (id item in title) {
                    NSLog(@"title: %@", item);
                    if ([item  isEqual: @""]) {
                        NSLog(@"the title is nil");
                    } else {
                        [_titleArray addObject:item];
                        NSLog(@"titleArray: %@", _titleArray);
                    }
                }
                
            }
        }
        
        for (NSData *data in mobilePhoneData) {
            NSArray *mobilePhoneRestoreArray = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class]
                                                    fromData:data error:nil];
            NSLog(@"mobilePhoneRestoreArray %@", mobilePhoneRestoreArray);
            for (id mobilePhone in mobilePhoneRestoreArray) {
                NSLog(@"item is %@", mobilePhone);
                for (id item in mobilePhone) {
                    NSLog(@"mobilePhone: %@", item);
                    if ([item  isEqual: @""]) {
                        NSLog(@"the mobilePhone is nil");
                    } else {
                        [_mobilePhoneArray addObject:item];
                        NSLog(@"mobilePhoneArray: %@", _mobilePhoneArray);
                    }
                }
                
            }
        }
        
        for (NSData *data in workPhoneData) {
            NSArray *workPhoneRestoreArray = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class]
                                                    fromData:data error:nil];
            NSLog(@"workPhoneRestoreArray %@", workPhoneRestoreArray);
            for (id workPhone in workPhoneRestoreArray) {
                NSLog(@"item is %@", workPhone);
                for (id item in workPhone) {
                    NSLog(@"workPhone: %@", item);
                    if ([item  isEqual: @""]) {
                        NSLog(@"the workPhone is nil");
                    } else {
                        [_workPhoneArray addObject:item];
                        NSLog(@"workPhoneArray: %@", _workPhoneArray);
                    }
                }
                
            }
        }
        
        for (NSData *data in faxData) {
            NSArray *faxRestoreArray = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class]
                                                    fromData:data error:nil];
            NSLog(@"faxRestoreArray %@", faxRestoreArray);
            for (id fax in faxRestoreArray) {
                NSLog(@"item is %@", fax);
                for (id item in fax) {
                    NSLog(@"fax: %@", item);
                    if ([item  isEqual: @""]) {
                        NSLog(@"the fax is nil");
                    } else {
                        [_faxArray addObject: item];
                        NSLog(@"faxArray: %@", _faxArray);
                    }
                }
                
            }
        }
        
        for (NSData *data in emailData) {
            NSArray *emailRestoreArray = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class]
                                                    fromData:data error:nil];
            NSLog(@"emailRestoreArray %@", emailRestoreArray);
            for (id email in emailRestoreArray) {
                NSLog(@"item is %@", email);
                for (id item in email) {
                    NSLog(@"email: %@", item);
                    if ([item  isEqual: @""]) {
                        NSLog(@"the email is nil");
                    } else {
                        [_emailArray addObject: item];
                        NSLog(@"emailArray: %@", _emailArray);
                    }
                }
                
            }
        }
        
        for (NSData *data in addressData) {
            NSArray *addressRestoreArray = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class]
                                                    fromData:data error:nil];
            NSLog(@"addressRestoreArray %@", addressRestoreArray);
            for (id address in addressRestoreArray) {
                NSLog(@"item is %@", address);
                for (id item in address) {
                    NSLog(@"address: %@", item);
                    if ([item  isEqual: @""]) {
                        NSLog(@"the address is nil");
                    } else {
                        [_addressArray addObject: item];
                        NSLog(@"addressArray %@", _addressArray);
                    }
                }
                
            }
        }

    }

    [self.tableView reloadData];
}




- (IBAction)doneButton:(id)sender {
    
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    [self.delegate sendCustomerDetails:selectedRows];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 9;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return self.nameArray.count;
        case 1:
            return self.companyArray.count;
        case 2:
            return self.departmentArray.count;
        case 3:
            return self.titleArray.count;
        case 4:
            return self.mobilePhoneArray.count;
        case 5:
            return self.workPhoneArray.count;
        case 6:
            return self.faxArray.count;
        case 7:
            return self.emailArray.count;
        default:
            return self.addressArray.count;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"customerDetailsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    for(UIView *view in cell.contentView.subviews){
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = _nameArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
        
    } else if (indexPath.section == 1) {
        cell.textLabel.text = _companyArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
        
    } else if (indexPath.section == 2) {
        cell.textLabel.text = _departmentArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
        
    } else if (indexPath.section == 3) {
        cell.textLabel.text = _titleArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
        
    } else if (indexPath.section == 4) {
        cell.textLabel.text = _mobilePhoneArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
        
    } else if (indexPath.section == 5) {
        cell.textLabel.text = _workPhoneArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
        
    } else if (indexPath.section == 6) {
        cell.textLabel.text = _faxArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
        
    } else if (indexPath.section == 7) {
        cell.textLabel.text = _emailArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
        
    } else if (indexPath.section == 8) {
        cell.textLabel.text = _addressArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    }
    
    return cell;
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    [self.tableView reloadData];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}



@end
