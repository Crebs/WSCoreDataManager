//
//  NSManagedObject+Incravo.m
//  spending
//
//  Created by Riley Crebs on 4/8/14.
//  Copyright (c) 2014 Riley Crebs. All rights reserved.
//

#import "NSManagedObject+Incravo.h"

#import "ModelManager.h"

@implementation NSManagedObject (Incravo)

- (void)save:(void (^)())completed failureBlock:(void (^)(NSError* error))failure {
    __block BOOL saved = NO;
    [self.managedObjectContext performBlockAndWait:^{
        NSError* error = nil;
        saved = [self.managedObjectContext save:&error];
        if (error && failure) {
            failure(error);
        }
        else if (completed) {
            completed();
        }
        
    }];
}

- (void)deleteObject {
    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext deleteObject:self];
    }];
}

+ (NSManagedObject*)getEntity:(NSString*)entityId keyPath:(NSString*)keyPath entityName:(NSString*)entityName modelManager:(ModelManager*)mm error:(NSError*__autoreleasing*)error {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K = %@", keyPath, entityId];
    [request setPredicate:predicate];
    NSManagedObject* object = nil;
    NSArray* objects = [mm.context executeFetchRequest:request error:error];
    if ([objects count]) {
        object = objects[0];
    }
    return object;
}
@end
