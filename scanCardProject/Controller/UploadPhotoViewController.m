//
//  ViewController.m
//  scanCardProject
//
//  Created by JXInfo on 2021/9/30.
//  Copyright © 2021 JXInfo. All rights reserved.
//

#import "UploadPhotoViewController.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CommonCrypto/CommonDigest.h>
#import "SVProgressHUD/SVProgressHUD.h"
#import "CustomerTableViewController.h"
#import "AppDelegate.h"



@interface UploadPhotoViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) UITabBarController *tabBarController;
@property (weak, nonatomic) IBOutlet UITabBarItem *tabBar;

@property (weak, nonatomic) IBOutlet UIButton *uploadButton;

@property (strong, nonatomic) NSManagedObjectContext *context;

@property (strong, nonatomic) NSNumber *timeStampNumber;
@property (strong, nonatomic) NSMutableArray *name;
@property (strong, nonatomic) NSMutableArray *company;
@property (strong, nonatomic) NSMutableArray *department;
@property (strong, nonatomic) NSMutableArray *customerTitle;
@property (strong, nonatomic) NSMutableArray *phoneNumber;
@property (strong, nonatomic) NSMutableArray *workTelephone;
@property (strong, nonatomic) NSMutableArray *fax;
@property (strong, nonatomic) NSMutableArray *email;
@property (strong, nonatomic) NSMutableArray *address;

@property (strong, nonatomic) NSMutableDictionary *listOfCustomerData;


@end

@implementation UploadPhotoViewController

NSString *url = @"https://webapi.xfyun.cn/v1/service/v1/ocr/business_card";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _uploadButton.backgroundColor = [[UIColor alloc]initWithRed:0.0/255.0 green:139.0/255.0 blue:139.0/255.0 alpha:1.0];
    _uploadButton.tintColor = [[UIColor alloc]initWithRed:248.0/255.0 green:248.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    
    
    NSLog(@"edrd%@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
}

#pragma mark - upload button

- (IBAction)uploadButtonPressed:(UIButton *)sender {

    //create a object for UIImagePickerController and set it to be a delegate.
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.editing = YES;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //camera event.
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相機" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [alertController dismissViewControllerAnimated:YES completion:^ {
            // check if this camera is supported.
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                //check if there is a rear lens.
                if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
                    
                    //setting UIImagePickerController attributes.
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    imagePicker.delegate = self;
                    imagePicker.allowsEditing = YES;
                    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
                    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
                    imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                }
            } else {
                NSLog(@"No Camera Device");
            }
            //navigate to the camera.
            [self presentViewController:imagePicker animated:YES completion:nil];
        }];
        
    }];
    
    // gallery event.
    UIAlertAction *gallery = [UIAlertAction actionWithTitle:@"照片圖庫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        // setting UIImagePickerController attributes.
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        // navigate to the gallery.
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    // cancel event.
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    // adding an icon on each option.
    [camera setValue:[[UIImage imageNamed:@"camera.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [gallery setValue:[[UIImage imageNamed:@"folder.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    
    // adding action of each.
    [alertController addAction: camera];
    [alertController addAction: gallery];
    [alertController addAction: cancel];
    
    // presenting sheet alert.
    [self presentViewController: alertController animated:YES completion:nil];
    
}
#pragma mark - imagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    //captured photo.
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self apiConnect:image];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - API connect

-(void) apiConnect: (UIImage*) image {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD show];
    });
    // app id
    NSString *APP_KEY = @"7926ndkduy27kbmjh28346ghxmg91237fd";
    // api key
    NSString *APP_SECRET = @"171023mfsdhf623jas39fj1230vs23f434";
    // set url Where to upload image
    NSString *SCAN_URL = @"http://bcr.jxinfo.com.tw/V1/?lang=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19";
    
    
    // Convert Image to NSData
    NSData *dataImage = UIImageJPEGRepresentation(image, 0.7);
    
    // Create 'POST' MutableRequest with Data and Other Image Attachment.
    NSMutableURLRequest* request= [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:SCAN_URL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:APP_KEY forHTTPHeaderField:@"app-key"];
    [request setValue:APP_SECRET forHTTPHeaderField:@"app-secret"];
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[NSData dataWithData:dataImage]];
    [request setHTTPBody:postbody];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *reply = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        [self customerData:reply];
        
//        NSLog(@"Request reply: %@", reply);
        
    }] resume];
    
}

#pragma mark - Fetch customer data

-(void) customerData: (NSDictionary*) customerData {
    
    NSArray *customerDataArray = customerData[@"result"][@"item_list"];
    
    self.name = [[NSMutableArray alloc] init];
    self.company = [[NSMutableArray alloc] init];
    self.department = [[NSMutableArray alloc]init];
    self.customerTitle = [[NSMutableArray alloc]init];
    self.phoneNumber = [[NSMutableArray alloc]init];
    self.workTelephone = [[NSMutableArray alloc]init];
    self.fax = [[NSMutableArray alloc]init];
    self.email = [[NSMutableArray alloc]init];
    self.address = [[NSMutableArray alloc]init];
    
    self.listOfCustomerData = [NSMutableDictionary dictionary];
    
    
    for (id data in customerDataArray) {
        for (id item in data) {
            NSLog(@"value: %@ key: %@", item, [data objectForKey:item]);
            
            if ([[data objectForKey:@"key"]  isEqual: @"name"]) {
                
                [_name addObject:[data objectForKey:@"value"]];
                
            } else if ([[data objectForKey:@"key"]  isEqual: @"company"]) {
                
                [_company addObject:[data objectForKey:@"value"]];
                
            } else if ([[data objectForKey:@"key"]  isEqual: @"department"]) {
                
                [_department addObject:[data objectForKey:@"value"]];
                
            } else if ([[data objectForKey:@"key"]  isEqual: @"title"]) {
                
                [_customerTitle addObject:[data objectForKey:@"value"]];
                
            } else if ([[data objectForKey:@"key"]  isEqual: @"telephone"]) {
                
                [_phoneNumber addObject:[data objectForKey:@"value"]];
                
            } else if ([[data objectForKey:@"key"]  isEqual: @"work_tel"]) {
                
                [_workTelephone addObject:[data objectForKey:@"value"]];
                
            } else if ([[data objectForKey:@"key"]  isEqual: @"fax"]) {
                
                [_fax addObject:[data objectForKey:@"value"]];
                
            } else if ([[data objectForKey:@"key"]  isEqual: @"email"]){
                
                [_email addObject:[data objectForKey:@"value"]];
                
            } else if ([[data objectForKey:@"key"]  isEqual: @"address"]) {
                
                [_address addObject:[data objectForKey:@"value"]];
                
            }
            break;
        }
        
    }
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    _timeStampNumber = [NSNumber numberWithDouble: timeStamp];
    
    [_listOfCustomerData setValue:_timeStampNumber forKey:@"timeStamp"];
    [_listOfCustomerData setValue:_name forKey:@"name"];
    [_listOfCustomerData setValue:_company forKey:@"company"];
    [_listOfCustomerData setValue:_department forKey:@"department"];
    [_listOfCustomerData setValue:_customerTitle forKey:@"title"];
    [_listOfCustomerData setValue:_phoneNumber forKey:@"mobile_phone"];
    [_listOfCustomerData setValue:_workTelephone forKey:@"work_phone"];
    [_listOfCustomerData setValue:_fax forKey:@"fax"];
    [_listOfCustomerData setValue:_email forKey:@"email"];
    [_listOfCustomerData setValue:_address forKey:@"address"];
    
    NSLog(@"list of customer data: %@", _listOfCustomerData);
    
    [self saveCustomer:_listOfCustomerData];
    
}


#pragma mark - Saving customer

-(void) saveCustomer:(NSMutableDictionary *)customerData {
    
    NSError *error = nil;
    
    NSMutableArray *nameArray = [[NSMutableArray alloc] init];
    NSMutableArray *companyArray = [[NSMutableArray alloc] init];
    NSMutableArray *departmentArray = [[NSMutableArray alloc] init];
    NSMutableArray *titleArray = [[NSMutableArray alloc] init];
    NSMutableArray *mobilePhoneArray = [[NSMutableArray alloc] init];
    NSMutableArray *workPhoneArray = [[NSMutableArray alloc] init];
    NSMutableArray *faxArray = [[NSMutableArray alloc] init];
    NSMutableArray *emailArray = [[NSMutableArray alloc] init];
    NSMutableArray *addressArray = [[NSMutableArray alloc] init];
    
    _context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    NSManagedObject *customerItem = [NSEntityDescription insertNewObjectForEntityForName:@"CustomerItem" inManagedObjectContext:_context];
    
    for (id key in customerData) {
        
        if ([key isEqual: @"timeStamp"]){
            [customerItem setValue:[customerData objectForKey:key] forKey:@"timeStamp"];
            NSLog(@"saving timeStamp success");
            
        } else if([key isEqual: @"name"]) {
            [nameArray addObject:[customerData objectForKey:key]];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:nameArray requiringSecureCoding:NO error:&error];
            [customerItem setValue: data forKey:@"name"];
            NSLog(@"saving name success");
            
        } else if ([key isEqual: @"company"]){
            [companyArray addObject:[customerData objectForKey:key]];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:companyArray requiringSecureCoding:NO error:&error];
            [customerItem setValue: data forKey:@"company"];
            NSLog(@"saving company success");
            
        } else if ([key isEqual: @"department"]) {
            [departmentArray addObject:[customerData objectForKey:key]];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:departmentArray requiringSecureCoding:NO error:&error];
            [customerItem setValue: data forKey:@"department"];
            NSLog(@"saving department success");
            
        } else if ([key isEqual: @"title"]) {
            [titleArray addObject:[customerData objectForKey:key]];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:titleArray requiringSecureCoding:NO error:&error];
            [customerItem setValue: data forKey:@"title"];
            NSLog(@"saving title success");
            
        } else if ([key isEqual: @"mobile_phone"]) {
            [mobilePhoneArray addObject:[customerData objectForKey:key]];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:mobilePhoneArray requiringSecureCoding:NO error:&error];
            [customerItem setValue: data forKey:@"mobilePhone"];
            NSLog(@"saving mobile phone success");
            
        } else if ([key isEqual: @"work_phone"]) {
            [workPhoneArray addObject:[customerData objectForKey:key]];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:workPhoneArray requiringSecureCoding:NO error:&error];
            [customerItem setValue: data forKey:@"workPhone"];
            NSLog(@"saving work phone success");
            
        } else if ([key isEqual: @"fax"]) {
            [faxArray addObject:[customerData objectForKey:key]];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:faxArray requiringSecureCoding:NO error:&error];
            [customerItem setValue: data forKey:@"fax"];
            NSLog(@"saving fax success");
            
        } else if ([key isEqual: @"email"]) {
            [emailArray addObject:[customerData objectForKey:key]];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:emailArray requiringSecureCoding:NO error:&error];
            [customerItem setValue: data forKey:@"email"];
            NSLog(@"saving email success");
            
        } else if ([key isEqual: @"address"]) {
            [addressArray addObject:[customerData objectForKey:key]];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:addressArray requiringSecureCoding:NO error:&error];
            [customerItem setValue: data forKey:@"address"];
            NSLog(@"saving address success");
            
        }
    }
    
    if (![_context save:&error]) {
     NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
     abort();
    } else {
        NSLog(@"okkkkkkkk");
    }
    
    [_name addObject:@""];
    [_company addObject:@""];
    [_department addObject:@""];
    [_customerTitle addObject:@""];
    [_phoneNumber addObject:@""];
    [_workTelephone addObject:@""];
    [_fax addObject:@""];
    [_email addObject:@""];
    [_address addObject:@""];
    [_listOfCustomerData setValue:_name forKey:@"name"];
    [_listOfCustomerData setValue:_company forKey:@"company"];
    [_listOfCustomerData setValue:_department forKey:@"department"];
    [_listOfCustomerData setValue:_customerTitle forKey:@"title"];
    [_listOfCustomerData setValue:_phoneNumber forKey:@"mobile_phone"];
    [_listOfCustomerData setValue:_workTelephone forKey:@"work_phone"];
    [_listOfCustomerData setValue:_fax forKey:@"fax"];
    [_listOfCustomerData setValue:_email forKey:@"email"];
    [_listOfCustomerData setValue:_address forKey:@"address"];
    NSLog(@"listOfCustomerData empty added %@", _listOfCustomerData);
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"showCustomerSegue" sender:self];
    });
    
    [SVProgressHUD dismiss];
}

#pragma mark - Segue action

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
    CustomerTableViewController *controller = (CustomerTableViewController *)navController.topViewController;
    controller.customerData = _listOfCustomerData;
    controller.timeStamp = _timeStampNumber;
}



@end


