//
//  CustomerDetailsTableViewController.h
//  scanCardProject
//
//  Created by JXInfo on 2021/9/30.
//  Copyright © 2021 JXInfo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CustomerDetailsControllerDelegate <NSObject>

-(void)sendCustomerDetails:(NSArray *)selectedDataArray;

@end

@interface CustomerDetailsTableViewController : UITableViewController

@property (nonatomic, weak) id <CustomerDetailsControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
