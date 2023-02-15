//
//  CustomerTableViewController.m
//  scanCardProject
//
//  Created by JXInfo on 2021/9/30.
//  Copyright © 2021 JXInfo. All rights reserved.
//

#import "CustomerTableViewController.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "CustomerDetailsTableViewController.h"

@interface CustomerTableViewController ()

@property (strong, nonatomic)NSManagedObjectContext *context;

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

@property (strong, nonatomic) NSArray *results;
@property (strong, nonatomic) NSArray *temporaryArray;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *companyTextField;
@property (strong, nonatomic) IBOutlet UITextField *departmentTextField;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextField *mobilePhoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *workPhoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *faxTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextView *addressTextView;
@property (strong, nonatomic) IBOutlet UITextView *commentTextView;

@property (nonatomic, assign) BOOL count;

@end

@implementation CustomerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //keyboard controlling
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self loadCustomerData];
    
    // setEditing func called
    [self setEditing:YES animated:YES];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButton:)];
    
    NSLog(@"time stamp: %@", _timeStamp);
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma  mark - Updating data from customerDetailsTableViewController

- (void)sendCustomerDetails:(NSMutableArray *)selectedDataArray {
    NSLog(@"selected dataaaaaa: %@",selectedDataArray);

    for (NSIndexPath *path in selectedDataArray) {
        NSUInteger index = [path indexAtPosition:[path length] - 2];
        NSLog(@"%lu", index);

        if (index == 0) {
            [_nameArray addObject:selectedDataArray[0]];
            NSLog(@"yyyyyyyyyyyyyyy %@", _nameArray);
        }
    }

    [self updateCustomerData:selectedDataArray];
}


#pragma mark - Updating customer data

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
    
    _nameArray = [_customerData objectForKey:@"name"];
    _companyArray = [_customerData objectForKey:@"company"];
    _departmentArray = [_customerData objectForKey:@"department"];
    _titleArray = [_customerData objectForKey:@"title"];
    _mobilePhoneArray = [_customerData objectForKey:@"mobile_phone"];
    _workPhoneArray = [_customerData objectForKey:@"work_phone"];
    _faxArray = [_customerData objectForKey:@"fax"];
    _emailArray = [_customerData objectForKey:@"email"];
    _addressArray = [_customerData objectForKey:@"address"];
    
}

-(void)updateCustomerData:(NSArray *) selectedDataArray {

}

#pragma mark - Saving customer to SQLite

-(void)saveCustomer {
    
    NSError *error = nil;
    _context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    NSData *nameData = [NSKeyedArchiver archivedDataWithRootObject:_nameArray requiringSecureCoding:NO error:&error];
    NSData *companyData = [NSKeyedArchiver archivedDataWithRootObject:_companyArray requiringSecureCoding:NO error:&error];
    NSData *departmentData = [NSKeyedArchiver archivedDataWithRootObject:_departmentArray requiringSecureCoding:NO error:&error];
    NSData *titleData = [NSKeyedArchiver archivedDataWithRootObject:_titleArray requiringSecureCoding:NO error:&error];
    NSData *mobilePhoneData = [NSKeyedArchiver archivedDataWithRootObject:_mobilePhoneArray requiringSecureCoding:NO error:&error];
    NSData *workPhoneData = [NSKeyedArchiver archivedDataWithRootObject:_workPhoneArray requiringSecureCoding:NO error:&error];
    NSData *faxData = [NSKeyedArchiver archivedDataWithRootObject:_faxArray requiringSecureCoding:NO error:&error];
    NSData *emailData = [NSKeyedArchiver archivedDataWithRootObject:_emailArray requiringSecureCoding:NO error:&error];
    NSData *addressData = [NSKeyedArchiver archivedDataWithRootObject:_addressArray requiringSecureCoding:NO error:&error];
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"CustomerItem" inManagedObjectContext:_context]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"timeStamp = %@",[_results valueForKey:@"timeStamp"]]];
    [request setPredicate:predicate];
    
    NSArray *results = [_context executeFetchRequest:request error:&error];

    
    if (results.count == 0) {
        NSManagedObject *customerItem = [NSEntityDescription insertNewObjectForEntityForName:@"CustomerItem" inManagedObjectContext:_context];
        [customerItem setValue: nameData forKey:@"name"];
        NSLog(@"saving name success");
        [customerItem setValue: companyData forKey:@"company"];
        NSLog(@"saving company success");
        [customerItem setValue: departmentData forKey:@"department"];
        NSLog(@"saving department success");
        [customerItem setValue: titleData forKey:@"title"];
        NSLog(@"saving title success");
        [customerItem setValue: mobilePhoneData forKey:@"mobilePhone"];
        NSLog(@"saving mobilePhone success");
        [customerItem setValue: workPhoneData forKey:@"workPhone"];
        NSLog(@"saving workPhone success");
        [customerItem setValue: faxData forKey:@"fax"];
        NSLog(@"saving fax success");
        [customerItem setValue: emailData forKey:@"email"];
        NSLog(@"saving email success");
        [customerItem setValue: addressData forKey:@"address"];
        NSLog(@"saving address success");
        
    } else {
        NSManagedObject* newCustomerItem = [results objectAtIndex:0];
        [newCustomerItem setValue: nameData forKey:@"name"];
        NSLog(@"updating name success");
        [newCustomerItem setValue: companyData forKey:@"company"];
        NSLog(@"updating company success");
        [newCustomerItem setValue: departmentData forKey:@"department"];
        NSLog(@"updating department success");
        [newCustomerItem setValue: titleData forKey:@"title"];
        NSLog(@"updating title success");
        [newCustomerItem setValue: mobilePhoneData forKey:@"mobilePhone"];
        NSLog(@"updating mobilePhone success");
        [newCustomerItem setValue: workPhoneData forKey:@"workPhone"];
        NSLog(@"updating workPhone success");
        [newCustomerItem setValue: faxData forKey:@"fax"];
        NSLog(@"updating fax success");
        [newCustomerItem setValue: emailData forKey:@"email"];
        NSLog(@"updating email success");
        [newCustomerItem setValue: addressData forKey:@"address"];
        NSLog(@"updating address success");
    }
    

    if (![_context save:&error]) {
     NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
     abort();
    } else {
        NSLog(@"okkkkkkkk");
    }
    
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"新增聯絡人成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:confirm];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)saveCurrentInfo {

    if (_count) {
        if (_nameTextField.text && _nameTextField.text.length > 0) {
            [_nameArray addObject:_nameTextField.text];
            NSLog(@"nameArray: %@", _nameArray);
            
        } else if (_companyTextField.text && _companyTextField.text.length > 0) {
            [_companyArray addObject:_companyTextField.text];
            NSLog(@"companyArray: %@", _companyArray);
            
        } else if (_departmentTextField.text && _departmentTextField.text.length > 0) {
            [_departmentArray addObject:_departmentTextField.text];
            NSLog(@"departmentArray: %@", _departmentArray);
            
        } else if (_titleTextField.text && _titleTextField.text.length > 0) {
            [_titleArray addObject:_titleTextField.text];
            NSLog(@"titleArray: %@", _titleArray);
            
        } else if (_mobilePhoneTextField.text && _mobilePhoneTextField.text.length > 0) {
            [_mobilePhoneArray addObject:_mobilePhoneTextField.text];
            NSLog(@"mobilePhone: %@", _mobilePhoneArray);
            
        } else if (_workPhoneTextField.text && _workPhoneTextField.text.length > 0) {
            [_workPhoneArray addObject:_workPhoneTextField.text];
            NSLog(@"workPhoneArray: %@", _workPhoneArray);
            
        } else if (_faxTextField.text && _faxTextField.text.length > 0) {
            [_faxArray addObject:_faxTextField.text];
            NSLog(@"faxArray: %@", _faxArray);
            
        } else if (_emailTextField.text && _emailTextField.text.length > 0) {
            [_emailArray addObject:_emailTextField.text];
            NSLog(@"emailArray: %@", _emailArray);
            
        } else if (_addressTextView.text && _addressTextView.text.length > 0) {
            [_addressArray addObject:_addressTextView.text];
            NSLog(@"addressArray: %@", _addressArray);
            
        }
    }
    self.count = NO;

    [self saveCustomer];
}

-(void)removeEmpty: (UIButton *) sender {

    _temporaryArray = [NSArray arrayWithArray:_nameArray];
    for (id item in _temporaryArray) {
        if ([item  isEqual: @""]) {
            [_nameArray removeObject:item];
            NSLog(@"removed successfully: %@", _nameArray);
        } else {
            NSLog(@"removed unsuccessfully: %@", _nameArray);
        }
    }

    _temporaryArray = [NSArray arrayWithArray:_companyArray];
    for (id item in _temporaryArray) {
        if ([item  isEqual: @""]) {
            [_companyArray removeObject:item];
            NSLog(@"removed successfully: %@", _companyArray);
        } else {
            NSLog(@"removed unsuccessfully: %@", _companyArray);
        }
    }

    _temporaryArray = [NSArray arrayWithArray:_departmentArray];
    for (id item in _temporaryArray) {
        if ([item  isEqual: @""]) {
            [_departmentArray removeObject:item];
            NSLog(@"removed successfully: %@", _departmentArray);
        } else {
            NSLog(@"removed unsuccessfully: %@", _departmentArray);
        }
    }

    _temporaryArray = [NSArray arrayWithArray:_titleArray];
    for (id item in _temporaryArray) {
        if ([item  isEqual: @""]) {
            [_titleArray removeObject:item];
            NSLog(@"removed successfully: %@", _titleArray);
        } else {
            NSLog(@"removed unsuccessfully: %@", _titleArray);
        }
    }

    _temporaryArray = [NSArray arrayWithArray:_mobilePhoneArray];
    for (id item in _temporaryArray) {
        if ([item  isEqual: @""]) {
            [_mobilePhoneArray removeObject:item];
            NSLog(@"removed successfully: %@", _mobilePhoneArray);
        } else {
            NSLog(@"removed unsuccessfully: %@", _mobilePhoneArray);
        }
    }

    _temporaryArray = [NSArray arrayWithArray:_workPhoneArray];
    for (id item in _temporaryArray) {
        if ([item  isEqual: @""]) {
            [_workPhoneArray removeObject:item];
            NSLog(@"removed successfully: %@", _workPhoneArray);
        } else {
            NSLog(@"removed unsuccessfully: %@", _workPhoneArray);
        }
    }

    _temporaryArray = [NSArray arrayWithArray:_faxArray];
    for (id item in _temporaryArray) {
        if ([item  isEqual: @""]) {
            [_faxArray removeObject:item];
            NSLog(@"removed successfully: %@", _faxArray);
        } else {
            NSLog(@"removed unsuccessfully: %@", _faxArray);
        }
    }

    _temporaryArray = [NSArray arrayWithArray:_emailArray];
    for (id item in _temporaryArray) {
        if ([item  isEqual: @""]) {
            [_emailArray removeObject:item];
            NSLog(@"removed successfully: %@", _emailArray);
        } else {
            NSLog(@"removed unsuccessfully: %@", _emailArray);
        }
    }

    _temporaryArray = [NSArray arrayWithArray:_addressArray];
    for (id item in _temporaryArray) {
        if ([item  isEqual: @""]) {
            [_addressArray removeObject:item];
            NSLog(@"removed successfully: %@", _addressArray);
        } else {
            NSLog(@"removed unsuccessfully: %@", _addressArray);
        }
    }

    [self saveCurrentInfo];

}

#pragma mark - Navigation bar button action

-(void)cancelButton:(UIBarButtonItem *)sender{
    
    NSError *error = nil;
    _context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"CustomerItem" inManagedObjectContext:_context]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"timeStamp = %@", _timeStamp]];
    [request setPredicate:predicate];
    
    NSArray *results = [_context executeFetchRequest:request error:&error];
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"確定要捨棄更動嗎？" preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"放棄所作更動" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        for (NSManagedObject *managedObject in results)
            {
                [self->_context deleteObject:managedObject];
                NSLog(@"item removed: %@", managedObject);
            }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [cancel setValue:[UIColor redColor] forKey:@"titleTextColor"];
    
    UIAlertAction *edit = [UIAlertAction actionWithTitle:@"繼續編輯" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancel];
    [alert addAction:edit];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)advancedSettingsButton:(UIBarButtonItem *)sender {

    [self performSegueWithIdentifier:@"showDetailsSegue" sender:self];

}

#pragma  mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 11;
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
        case 9:
            return 1;
        default:
            return 1;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 8 && indexPath.row == [_addressArray count] -1) {
        return 50;
    } else if (indexPath.section == 8) {
        return 80;
    } else if (indexPath.section == 9) {
        return 130;
    }
    
    return 50;
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return @"姓名";
        case 1: return @"公司";
        case 2: return @"部門";
        case 3: return @"職稱";
        case 4: return @"行動電話";
        case 5: return @"公司電話";
        case 6: return @"傳真";
        case 7: return @"電子郵件";
        case 8: return @"地址";
        case 9: return @"附註";
        default: return @"";
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *CellIdentifier = @"customerItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    for(UIView *view in cell.contentView.subviews){
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (indexPath.section == 0 && indexPath.row == [_nameArray count] - 1) {
        UILabel *addNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 334, 34)];
        [addNameLabel setText:@"姓名"];
        [addNameLabel setFont:[UIFont systemFontOfSize:15]];
        [cell.contentView addSubview:addNameLabel];

    } else if (indexPath.section == 0) {
        _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 8, 334, 34)];
        _nameTextField.font = [UIFont systemFontOfSize:17];
        _nameTextField.textColor = [[UIColor alloc]initWithRed:28.0/255.0 green:134.0/255.0 blue:238.0/255.0 alpha:1.0];
        _nameTextField.placeholder = @"姓名";
        _nameTextField.borderStyle = UITextBorderStyleNone;
        _nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _nameTextField.text = _nameArray[indexPath.row];
        [cell.contentView addSubview:_nameTextField];
        
        
        
    } else if (indexPath.section == 1 && indexPath.row == [_companyArray count] - 1) {
        UILabel *addCompanyLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 334, 34)];
        [addCompanyLabel setText:@"公司"];
        [addCompanyLabel setFont:[UIFont systemFontOfSize:15]];
        [cell.contentView addSubview:addCompanyLabel];
        
    } else if (indexPath.section == 1) {
        _companyTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 8, 334, 34)];
        _companyTextField.font = [UIFont systemFontOfSize:17];
        _companyTextField.textColor = [[UIColor alloc]initWithRed:28.0/255.0 green:134.0/255.0 blue:238.0/255.0 alpha:1.0];
        _companyTextField.placeholder = @"公司";
        _companyTextField.borderStyle = UITextBorderStyleNone;
        _companyTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _companyTextField.text = _companyArray[indexPath.row];
        [cell.contentView addSubview:_companyTextField];
        
        
        
    } else if (indexPath.section == 2 && indexPath.row == [_departmentArray count] - 1) {
        UILabel *addDepartmentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 334, 34)];
        [addDepartmentLabel setText:@"部門"];
        [addDepartmentLabel setFont:[UIFont systemFontOfSize:15]];
        [cell.contentView addSubview:addDepartmentLabel];
        
    } else if (indexPath.section == 2) {
        _departmentTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 8, 334, 34)];
        _departmentTextField.font = [UIFont systemFontOfSize:17];
        _departmentTextField.textColor = [[UIColor alloc]initWithRed:28.0/255.0 green:134.0/255.0 blue:238.0/255.0 alpha:1.0];
        _departmentTextField.placeholder = @"部門";
        _departmentTextField.borderStyle = UITextBorderStyleNone;
        _departmentTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _departmentTextField.text = _departmentArray[indexPath.row];
        [cell.contentView addSubview:_departmentTextField];
        
        
    } else if (indexPath.section == 3 && indexPath.row == [_titleArray count] - 1) {
        UILabel *addTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 334, 34)];
        [addTitleLabel setText:@"職稱"];
        [addTitleLabel setFont:[UIFont systemFontOfSize:15]];
        [cell.contentView addSubview:addTitleLabel];
        
    } else if (indexPath.section == 3) {
        _titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 8, 334, 34)];
        _titleTextField.font = [UIFont systemFontOfSize:17];
        _titleTextField.textColor = [[UIColor alloc]initWithRed:28.0/255.0 green:134.0/255.0 blue:238.0/255.0 alpha:1.0];
        _titleTextField.placeholder = @"職稱";
        _titleTextField.borderStyle = UITextBorderStyleNone;
        _titleTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _titleTextField.text = _titleArray[indexPath.row];
        [cell.contentView addSubview:_titleTextField];
        
        
    } else if (indexPath.section == 4 && indexPath.row == [_mobilePhoneArray count] - 1) {
        UILabel *addMobilePhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 334, 34)];
        [addMobilePhoneLabel setText:@"行動電話"];
        [addMobilePhoneLabel setFont:[UIFont systemFontOfSize:15]];
        [cell.contentView addSubview:addMobilePhoneLabel];
        
    } else if (indexPath.section == 4) {
        _mobilePhoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 8, 334, 34)];
        _mobilePhoneTextField.font = [UIFont systemFontOfSize:17];
        _mobilePhoneTextField.textColor = [[UIColor alloc]initWithRed:28.0/255.0 green:134.0/255.0 blue:238.0/255.0 alpha:1.0];
        _mobilePhoneTextField.placeholder = @"行動電話";
        _mobilePhoneTextField.borderStyle = UITextBorderStyleNone;
        _mobilePhoneTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _mobilePhoneTextField.text = _mobilePhoneArray[indexPath.row];
        [cell.contentView addSubview:_mobilePhoneTextField];
        
        
        
    } else if (indexPath.section == 5 && indexPath.row == [_workPhoneArray count] - 1) {
        UILabel *addWorkPhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 334, 34)];
        [addWorkPhoneLabel setText:@"公司電話"];
        [addWorkPhoneLabel setFont:[UIFont systemFontOfSize:15]];
        [cell.contentView addSubview:addWorkPhoneLabel];
        
    } else if (indexPath.section == 5) {
        _workPhoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 8, 334, 34)];
        _workPhoneTextField.font = [UIFont systemFontOfSize:17];
        _workPhoneTextField.textColor = [[UIColor alloc]initWithRed:28.0/255.0 green:134.0/255.0 blue:238.0/255.0 alpha:1.0];
        _workPhoneTextField.placeholder = @"公司電話";
        _workPhoneTextField.borderStyle = UITextBorderStyleNone;
        _workPhoneTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _workPhoneTextField.text = _workPhoneArray[indexPath.row];
        [cell.contentView addSubview:_workPhoneTextField];
        
        
        
    } else if (indexPath.section == 6 && indexPath.row == [_faxArray count] - 1) {
        UILabel *addFaxLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 334, 34)];
        [addFaxLabel setText:@"傳真"];
        [addFaxLabel setFont:[UIFont systemFontOfSize:15]];
        [cell.contentView addSubview:addFaxLabel];
        
    } else if (indexPath.section == 6) {
        _faxTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 8, 334, 34)];
        _faxTextField.font = [UIFont systemFontOfSize:17];
        _faxTextField.textColor = [[UIColor alloc]initWithRed:28.0/255.0 green:134.0/255.0 blue:238.0/255.0 alpha:1.0];
        _faxTextField.placeholder = @"傳真";
        _faxTextField.borderStyle = UITextBorderStyleNone;
        _faxTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _faxTextField.text = _faxArray[indexPath.row];
        [cell.contentView addSubview:_faxTextField];
        
        

    } else if (indexPath.section == 7 && indexPath.row == [_emailArray count] -1) {
        UILabel *addEmailLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 334, 34)];
        [addEmailLabel setText:@"電子郵件"];
        [addEmailLabel setFont:[UIFont systemFontOfSize:15]];
        [cell.contentView addSubview:addEmailLabel];
        
    } else if (indexPath.section == 7) {
        _emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 8, 334, 34)];
        _emailTextField.font = [UIFont systemFontOfSize:17];
        _emailTextField.textColor = [[UIColor alloc]initWithRed:28.0/255.0 green:134.0/255.0 blue:238.0/255.0 alpha:1.0];
        _emailTextField.placeholder = @"電子郵件";
        _emailTextField.borderStyle = UITextBorderStyleNone;
        _emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _emailTextField.text = _emailArray[indexPath.row];
        [cell.contentView addSubview:_emailTextField];
        
        
        
    } else if (indexPath.section == 8 && indexPath.row == [_addressArray count] -1) {
        UILabel *addAddressLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 334, 34)];
        [addAddressLabel setText:@"地址"];
        [addAddressLabel setFont:[UIFont systemFontOfSize:15]];
        [cell.contentView addSubview:addAddressLabel];
        
    } else if (indexPath.section == 8) {
        _addressTextView = [[UITextView alloc]initWithFrame:CGRectMake(20,6,256,69)];
        _addressTextView.font = [UIFont systemFontOfSize:17];
        _addressTextView.text = _addressArray[indexPath.row];
        _addressTextView.textColor = [[UIColor alloc]initWithRed:28.0/255.0 green:134.0/255.0 blue:238.0/255.0 alpha:1.0];
        [cell.contentView addSubview:_addressTextView];
        
        
        
    } else if (indexPath.section == 9) {
        _commentTextView = [[UITextView alloc]initWithFrame:CGRectMake(18,5,338,119)];
        _commentTextView.font = [UIFont systemFontOfSize:17];
        _commentTextView.textColor = [[UIColor alloc]initWithRed:28.0/255.0 green:134.0/255.0 blue:238.0/255.0 alpha:1.0];
        [cell.contentView addSubview:_commentTextView];
        
        
        
    } else if (indexPath.section == 10) {
        UIButton *addNewCustomerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addNewCustomerButton setFrame:CGRectMake(15,10,319,30)];
        [addNewCustomerButton setTitle:@"新增聯絡人" forState:UIControlStateNormal];
        [addNewCustomerButton setTitleColor:[UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [addNewCustomerButton addTarget:self action:@selector(removeEmpty:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:addNewCustomerButton];
    }
    
    return cell;
    
}


// enters editing mode
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    [self.tableView reloadData];
}


// setting if the row can be edit or not
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 9:
            return NO;
        case 10:
            return NO;
        default:
            return YES;
    }
}


// customizing the editing style of rows
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.tableView.editing) {
        
        if (indexPath.section == 0 && indexPath.row == [_nameArray count] - 1) {
            return UITableViewCellEditingStyleInsert;
        } else if (indexPath.section == 0){
            return UITableViewCellEditingStyleDelete;
        }
        
        if (indexPath.section == 1 && indexPath.row == [_companyArray count] - 1) {
            return UITableViewCellEditingStyleInsert;
        } else if (indexPath.section == 1) {
            return UITableViewCellEditingStyleDelete;
        }
        
        if (indexPath.section == 2 && indexPath.row == [_departmentArray count] - 1) {
            return UITableViewCellEditingStyleInsert;
        } else if (indexPath.section == 2) {
            return UITableViewCellEditingStyleDelete;
        }
        
        if (indexPath.section == 3 && indexPath.row == [_titleArray count] - 1 ) {
            return UITableViewCellEditingStyleInsert;
        } else if (indexPath.section == 3) {
            return UITableViewCellEditingStyleDelete;
        }
        
        if (indexPath.section == 4 && indexPath.row == [_mobilePhoneArray count] - 1) {
            return UITableViewCellEditingStyleInsert;
        } else if (indexPath.section == 4) {
            return UITableViewCellEditingStyleDelete;
        }
        
        if (indexPath.section == 5 && indexPath.row == [_workPhoneArray count] - 1) {
            return UITableViewCellEditingStyleInsert;
        } else if (indexPath.section == 5) {
            return UITableViewCellEditingStyleDelete;
        }
        
        if (indexPath.section == 6 && indexPath.row == [_faxArray count] - 1) {
            return UITableViewCellEditingStyleInsert;
        } else if (indexPath.section == 6) {
            return UITableViewCellEditingStyleDelete;
        }
        
        if (indexPath.section == 7 && indexPath.row == [_emailArray count] - 1) {
            return UITableViewCellEditingStyleInsert;
        } else if (indexPath.section == 7) {
            return UITableViewCellEditingStyleDelete;
        }
        
        if (indexPath.section == 8 && indexPath.row == [_addressArray count] - 1) {
            return UITableViewCellEditingStyleInsert;
        } else if (indexPath.section == 8) {
            return UITableViewCellEditingStyleDelete;
        }
    }
    
    return UITableViewCellEditingStyleNone;
}


//  updating the data-model array and deleting the row
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (indexPath.section == 0) {
            [_nameArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        } else if (indexPath.section == 1) {
            [_companyArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        } else if (indexPath.section == 2) {
            [_departmentArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        } else if (indexPath.section == 3) {
            [_titleArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        } else if (indexPath.section == 4) {
            [_mobilePhoneArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        } else if (indexPath.section == 5) {
            [_workPhoneArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        } else if (indexPath.section == 6) {
            [_faxArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        } else if (indexPath.section == 7) {
            [_emailArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        } else if (indexPath.section == 8) {
            [_addressArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        
    }
    
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        
        if(indexPath.section == 0 && indexPath.row == [_nameArray count] - 1) {
            [_nameArray addObject:@""];
            NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[_nameArray count]-1 inSection:0]];
            [[self tableView] insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
            [tableView reloadData];
            
        } else if (indexPath.section == 1 && indexPath.row == [_companyArray count] - 1) {
            [_companyArray addObject:@""];
            NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[_companyArray count]-1 inSection:1]];
            [[self tableView] insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
            [tableView reloadData];
            
        } else if (indexPath.section == 2 && indexPath.row == [_departmentArray count] - 1) {
            [_departmentArray addObject:@""];
            NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[_departmentArray count]-1 inSection:2]];
            [[self tableView] insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
            [tableView reloadData];
            
        } else if (indexPath.section == 3 && indexPath.row == [_titleArray count] - 1) {
            [_titleArray addObject:@""];
            NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[_titleArray count]-1 inSection:3]];
            [[self tableView] insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
            [tableView reloadData];
            
        } else if (indexPath.section == 4 && indexPath.row == [_mobilePhoneArray count] - 1) {
            [_mobilePhoneArray addObject:@""];
            NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[_mobilePhoneArray count]-1 inSection:4]];
            [[self tableView] insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
            [tableView reloadData];
            
        } else if (indexPath.section == 5 && indexPath.row == [_workPhoneArray count] - 1) {
            [_workPhoneArray addObject:@""];
            NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[_workPhoneArray count]-1 inSection:5]];
            [[self tableView] insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
            [tableView reloadData];
            
        } else if (indexPath.section == 6 && indexPath.row == [_faxArray count] - 1) {
            [_faxArray addObject:@""];
            NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[_faxArray count]-1 inSection:6]];
            [[self tableView] insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
            [tableView reloadData];
            
        } else if (indexPath.section == 7 && indexPath.row == [_emailArray count] - 1) {
            [_emailArray addObject:@""];
            NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[_emailArray count]-1 inSection:7]];
            [[self tableView] insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
            [tableView reloadData];
            
        } else if (indexPath.section == 8 && indexPath.row == [_addressArray count] - 1) {
            [_addressArray addObject:@""];
            NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[_addressArray count]-1 inSection:8]];
            [[self tableView] insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
            [tableView reloadData];
        }
    }
    
}


@end
