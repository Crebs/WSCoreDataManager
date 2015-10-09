//
//  CoreDataSession.m
//  spending
//
//  Created by Riley Crebs on 4/7/14.
//  Copyright (c) 2014 Riley Crebs. All rights reserved.
//

#import "CoreDataSession.h"

#import "CoreDataModelManager.h"
#import "NSFileManager+Extension.h"

#import <CoreData/CoreData.h>

@interface CoreDataSession ()

@end

@implementation CoreDataSession

#pragma mark - Public Methods


- (id) init {
	self = [super init];
	if (self) {
//		NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
//		[nc addObserver:self
//			   selector:@selector(storesWillChange:)
//				   name:NSPersistentStoreCoordinatorStoresWillChangeNotification
//				 object:nil];
//		[nc addObserver:self
//			   selector:@selector(storesDidChange:)
//				   name:NSPersistentStoreCoordinatorStoresDidChangeNotification
//				 object:nil];
//		[nc addObserver:self
//			   selector:@selector(didImportUbiquitousContent:)
//				   name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
//				 object:nil];
	}
	return self;
}

- (id)initWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator concurrencyType:(NSManagedObjectContextConcurrencyType)ct {
    if (self = [super init]) {
        if (coordinator) {
            _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:ct];
            [_context performBlockAndWait:^{
                [_context setPersistentStoreCoordinator:coordinator];
            }];
        }
    }
    return self;
}

- (NSArray *)findEntity:(NSString *)entity entityIds:(NSArray *)entityIds entityId:(NSString *)entityId error:(NSError **)error {
    
    NSFetchRequest* fr = [NSFetchRequest new];
    [fr setEntity:[NSEntityDescription entityForName:entity inManagedObjectContext:self.context]];
    [fr setPredicate:[NSPredicate predicateWithFormat:@"(%K IN %@)", entityId, entityIds]];
    NSArray *matchingEntities = [self.context executeFetchRequest:fr error:error];
    return matchingEntities;
}

- (NSArray*)createEntity:(NSString*)entity entityIds:(NSArray*)entityIds entityId:(NSString*)entityIdName {
    NSMutableArray* createdEntities = [NSMutableArray new];
    for (NSString* entityId in [entityIds copy]) {
        id newEntity = [NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:self.context];
        
        /* We are setting dirty to NO at this point because bulk creates is only used in sync. We are getting items from the server
        * and we don't want to treat new items coming from the server as dirty.
        */
        if ([newEntity respondsToSelector:@selector(dirty)]) {
            [newEntity setValue:@NO forKey:@"dirty"];
        }
        [newEntity setValue:entityId forKey:entityIdName];
        [createdEntities addObject:newEntity];
    }
    return createdEntities;
}

- (NSArray*)findOrCreateEntity:(NSString*)entity entityId:(NSString*)entityIdName entityIds:(NSArray*)entityIds error:(NSError**)error {
    // Fetch for existing entities
    NSArray *matchingEntities = [self findEntity:entity entityIds:entityIds entityId:entityIdName error:error];
    
    // Find entities that don't already exist.
    NSSet* existingEntityIds = [NSSet setWithArray:[matchingEntities valueForKeyPath:[NSString stringWithFormat:@"%@", entityIdName]]];
    NSMutableSet* entityIdsSet = [NSMutableSet setWithArray:entityIds];
    [entityIdsSet minusSet:existingEntityIds];
    
    // Create entites that need to be created
    NSArray* createdEntities = [self createEntity:entity entityIds:[entityIdsSet allObjects] entityId:entityIdName];
    
    // Combine created and found entity collections
    NSMutableArray* entities = [NSMutableArray arrayWithArray:createdEntities];
    [entities addObjectsFromArray:matchingEntities];
    return entities;
    
}

- (NSArray*)findDirtyEntities:(NSString*)entityName error:(NSError**)error {
    return [self findAllEntities:entityName predicate:[NSPredicate predicateWithFormat:@"dirty = nil OR dirty = YES"] error:error];
}

- (NSArray*)findAllEntities:(NSString*)entityName error:(NSError**)error {
    NSFetchRequest* fr = [NSFetchRequest new];
    [fr setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self.context]];
    return [self.context executeFetchRequest:fr error:error];
}

- (NSArray*)findAllEntities:(NSString*)entityName predicate:(NSPredicate*)predicate error:(NSError**)error {
    NSFetchRequest* fr = [NSFetchRequest new];
    [fr setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self.context]];
    [fr setPredicate:predicate];
    return [self.context executeFetchRequest:fr error:error];
}

@end
