//
//  CustomerTableViewController.h
//  scanCardProject
//
//  Created by JXInfo on 2021/9/30.
//  Copyright © 2021 JXInfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerDetailsTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomerTableViewController : UITableViewController <CustomerDetailsControllerDelegate>

@property (strong, nonatomic) NSMutableDictionary *customerData;
@property (weak, nonatomic) NSString *timeStamp;

@end

NS_ASSUME_NONNULL_END
