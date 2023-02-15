//
//  CustomerItem+CoreDataProperties.m
//  
//
//  Created by 胡淨淳 on 2021/10/27.
//
//

#import "CustomerItem+CoreDataProperties.h"

@implementation CustomerItem (CoreDataProperties)

+ (NSFetchRequest<CustomerItem *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"CustomerItem"];
}

@dynamic address;
@dynamic comment;
@dynamic company;
@dynamic department;
@dynamic email;
@dynamic fax;
@dynamic mobilePhone;
@dynamic name;
@dynamic timeStamp;
@dynamic title;
@dynamic workPhone;
@dynamic updater;

@end
