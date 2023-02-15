//
//  SingleContactTableViewController.m
//  scanCardProject
//
//  Created by 胡淨淳 on 2021/10/19.
//  Copyright © 2021 JXInfo. All rights reserved.
//

#import "SingleContactTableViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface SingleContactTableViewController () <UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *nameArray;
@property (strong, nonatomic) NSMutableArray *companyArray;
@property (strong, nonatomic) NSMutableArray *departmentArray;
@property (strong, nonatomic) NSMutableArray *titleArray;
@property (strong, nonatomic) NSMutableArray *mobilePhoneArray;
@property (strong, nonatomic) NSMutableArray *workPhoneArray;
@property (strong, nonatomic) NSMutableArray *faxArray;
@property (strong, nonatomic) NSMutableArray *emailArray;
@property (strong, nonatomic) NSMutableArray *addressArray;
@property (strong, nonatomic) NSMutableArray *commentArray;


@property (strong, nonatomic) NSArray *results;
@property (strong, nonatomic) NSMutableArray *listOfCustomerData;

@end

@implementation SingleContactTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Entring single contact page");
    
    //keyboard controlling
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self loadCustomerData];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}


- (IBAction)editButton:(UIBarButtonItem *)sender {
    [self setEditing:YES animated:YES];
}

#pragma mark - Loading customer info

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
    self.commentArray = [NSMutableArray array];
    
    self.listOfCustomerData = [NSMutableArray array];
    
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
//        NSArray *commentData = [_results valueForKey:@"comment"];

        for (NSData *data in nameData) {
            NSArray *nameRestoreArray = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class]
                                                    fromData:data error:nil];
            NSLog(@"nameRestoreArray %@", nameRestoreArray);
            
            for (id name in nameRestoreArray) {
                NSLog(@"name: %@", name);
                if(![name  isEqual: @""]) {
                    [_nameArray addObject:name];
                    
                } else {
                    NSLog(@"the name is nil");
                }

            }
        }
        [_listOfCustomerData addObject:_nameArray];
        
        
        for (NSData *data in companyData) {
            NSArray *companyRestoreArray = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class]
                                                    fromData:data error:nil];
            NSLog(@"companyRestoreArray %@", companyRestoreArray);
            
            for (id company in companyRestoreArray) {
                NSLog(@"company: %@", company);
                if(![company  isEqual: @""]) {
                    [_companyArray addObject:company];
                    
                } else {
                    NSLog(@"the company is nil");
                }

            }
        }
        [_listOfCustomerData addObject:_companyArray];
        
        
        for (NSData *data in departmentData) {
            NSArray *departmentRestoreArray = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class]
                                                    fromData:data error:nil];
            NSLog(@"departmentRestoreArray %@", departmentRestoreArray);
            
            for (id department in departmentRestoreArray) {
                NSLog(@"department: %@", department);
                if(![department  isEqual: @""]) {
                    [_departmentArray addObject:department];
                    
                } else {
                    NSLog(@"the department is nil");
                }

            }
        }
        [_listOfCustomerData addObject:_departmentArray];
        
        
        for (NSData *data in titleData) {
            NSArray *titleRestoreArray = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class]
                                                    fromData:data error:nil];
            NSLog(@"departmentRestoreArray %@", titleRestoreArray);
            
            for (id title in titleRestoreArray) {
                NSLog(@"title: %@", title);
                if(![title  isEqual: @""]) {
                    [_titleArray addObject:title];
                    
                } else {
                    NSLog(@"the title is nil");
                }

            }
        }
        [_listOfCustomerData addObject:_titleArray];
        
        
        for (NSData *data in mobilePhoneData) {
            NSArray *mobilePhoneRestoreArray = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class]
                                                    fromData:data error:nil];
            NSLog(@"mobilePhoneRestoreArray %@", mobilePhoneRestoreArray);
            
            for (id mobilePhone in mobilePhoneRestoreArray) {
                NSLog(@"mobilePhone: %@", mobilePhone);
                if(![mobilePhone  isEqual: @""]) {
                    [_mobilePhoneArray addObject:mobilePhone];
                    
                } else {
                    NSLog(@"the mobilePhone is nil");
                }

            }
        }
        [_listOfCustomerData addObject:_mobilePhoneArray];
        
        
        for (NSData *data in workPhoneData) {
            NSArray *workPhoneRestoreArray = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class]
                                                    fromData:data error:nil];
            NSLog(@"mobilePhoneRestoreArray %@", workPhoneRestoreArray);
            
            for (id workPhone in workPhoneRestoreArray) {
                NSLog(@"workPhone: %@", workPhone);
                if(![workPhone  isEqual: @""]) {
                    [_workPhoneArray addObject:workPhone];
                    
                } else {
                    NSLog(@"the workPhone is nil");
                }

            }
        }
        [_listOfCustomerData addObject:_workPhoneArray];
        
        
        for (NSData *data in faxData) {
            NSArray *faxRestoreArray = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class]
                                                    fromData:data error:nil];
            NSLog(@"faxRestoreArray %@", faxRestoreArray);
            
            for (id fax in faxRestoreArray) {
                NSLog(@"fax: %@", fax);
                if(![fax  isEqual: @""]) {
                    [_faxArray addObject:fax];
                    
                } else {
                    NSLog(@"the fax is nil");
                }

            }
        }
        [_listOfCustomerData addObject:_faxArray];
        
        
        for (NSData *data in emailData) {
            NSArray *emailRestoreArray = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class]
                                                    fromData:data error:nil];
            NSLog(@"emailRestoreArray %@", emailRestoreArray);
            
            for (id email in emailRestoreArray) {
                NSLog(@"email: %@", email);
                if(![email  isEqual: @""]) {
                    [_emailArray addObject:email];
                    
                } else {
                    NSLog(@"the email is nil");
                }

            }
        }
        [_listOfCustomerData addObject:_emailArray];
        
        
        for (NSData *data in addressData) {
            NSArray *addressRestoreArray = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class]
                                                    fromData:data error:nil];
            NSLog(@"addressRestoreArray %@", addressRestoreArray);
            
            for (id address in addressRestoreArray) {
                NSLog(@"address: %@", address);
                if(![address  isEqual: @""]) {
                    [_addressArray addObject:address];
                    
                } else {
                    NSLog(@"the address is nil");
                }

            }
        }
        [_listOfCustomerData addObject:_addressArray];
        
        
//        for (NSData *data in commentData) {
//            NSArray *commentRestoreArray = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class]
//                                                    fromData:data error:nil];
//            NSLog(@"commentRestoreArray %@", commentRestoreArray);
//
//            for (id comment in commentRestoreArray) {
//                NSLog(@"comment: %@", comment);
//                if(![comment  isEqual: @""]) {
//                    [_commentArray addObject:comment];
//
//                } else {
//                    NSLog(@"the comment is nil");
//                }
//
//            }
//        }
//        [_listOfCustomerData addObject:_commentArray];
  

    }
    NSLog(@"final listOfCustomerData: %@", _listOfCustomerData);

    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _listOfCustomerData.count;
    
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
        case 8:
            return self.addressArray.count;
        default:
            return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"contactDetailsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    if (indexPath.section == 0) {
        if (_nameArray) {
            cell.textLabel.text = @"姓名";
            cell.detailTextLabel.text = _nameArray[indexPath.row];
        }
        
    } else if (indexPath.section == 1) {
        if (_companyArray) {
            cell.textLabel.text = @"公司";
            cell.detailTextLabel.text = _companyArray[indexPath.row];
        }
        
    } else if (indexPath.section == 2) {
        if (_departmentArray) {
            cell.textLabel.text = @"部門";
            cell.detailTextLabel.text = _departmentArray[indexPath.row];
        }
        
    } else if (indexPath.section == 3) {
        if (_titleArray) {
            cell.textLabel.text = @"職稱";
            cell.detailTextLabel.text = _titleArray[indexPath.row];
        }
        
    } else if (indexPath.section == 4) {
        cell.textLabel.text = @"行動電話";
        cell.detailTextLabel.text = _mobilePhoneArray[indexPath.row];
        
    } else if (indexPath.section == 5) {
        if (_workPhoneArray) {
            cell.textLabel.text = @"公司電話";
            cell.detailTextLabel.text = _workPhoneArray[indexPath.row];
        }
        
    } else if (indexPath.section == 6) {
        if(_faxArray) {
            cell.textLabel.text = @"傳真";
            cell.detailTextLabel.text = _faxArray[indexPath.row];
        }
        
    } else if (indexPath.section == 7) {
        if(_emailArray) {
            cell.textLabel.text = @"電子信箱";
            cell.detailTextLabel.text = _emailArray[indexPath.row];
        }
        
    } else if (indexPath.section == 8) {
        if(_addressArray) {
            cell.textLabel.text = @"地址";
            cell.detailTextLabel.text = _addressArray[indexPath.row];
        }
        
    }
//    else if (indexPath.section == 9) {
//        cell.detailTextLabel.text = _commentArray[indexPath.row];
//        
//    }
 

    return cell;
}

// enters editing mode
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    [self.tableView reloadData];
}



@end
