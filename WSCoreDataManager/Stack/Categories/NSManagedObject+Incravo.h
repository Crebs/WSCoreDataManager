//
//  NSManagedObject+Incravo.h
//  spending
//
//  Created by Riley Crebs on 4/8/14.
//  Copyright (c) 2014 Riley Crebs. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ModelManager;

@interface NSManagedObject (Incravo)

- (void)save:(void (^)())completed failureBlock:(void (^)(NSError* error))failure;
- (void)deleteObject;
+ (NSManagedObject*)getEntity:(NSString*)entityId keyPath:(NSString*)keyPath entityName:(NSString*)entityName modelManager:(ModelManager*)mm error:(NSError*__autoreleasing*)error;
@end
