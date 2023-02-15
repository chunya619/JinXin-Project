//
//  CustomerItem+CoreDataProperties.h
//  
//
//  Created by 胡淨淳 on 2021/10/27.
//
//

#import "CustomerItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CustomerItem (CoreDataProperties)

+ (NSFetchRequest<CustomerItem *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, retain) NSData *address;
@property (nullable, nonatomic, retain) NSData *comment;
@property (nullable, nonatomic, retain) NSData *company;
@property (nullable, nonatomic, retain) NSData *department;
@property (nullable, nonatomic, retain) NSData *email;
@property (nullable, nonatomic, retain) NSData *fax;
@property (nullable, nonatomic, retain) NSData *mobilePhone;
@property (nullable, nonatomic, retain) NSData *name;
@property (nonatomic) int32_t timeStamp;
@property (nullable, nonatomic, retain) NSData *title;
@property (nullable, nonatomic, retain) NSData *workPhone;
@property (nullable, nonatomic, copy) NSString *updater;

@end

NS_ASSUME_NONNULL_END
