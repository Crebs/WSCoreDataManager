//
//  TestObject+CoreDataProperties.h
//  WSCoreDataManager
//
//  Created by Riley Crebs on 10/9/15.
//  Copyright © 2015 Incravo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TestObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestObject (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSDate *date;

@end

NS_ASSUME_NONNULL_END
