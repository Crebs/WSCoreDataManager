//
//  CoreDataSession.h
//  spending
//
//  Created by Riley Crebs on 4/7/14.
//  Copyright (c) 2014 Riley Crebs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

@interface CoreDataSession : NSObject
@property (strong,readonly,nonatomic) NSManagedObjectContext *context;

- (id)initWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator concurrencyType:(NSManagedObjectContextConcurrencyType)ct;

- (NSArray*)findOrCreateEntity:(NSString*)entity entityId:(NSString*)entityId entityIds:(NSArray*)entityIds error:(NSError**)error;
- (NSArray *)findEntity:(NSString *)entity entityIds:(NSArray *)entityIds entityId:(NSString *)entityId error:(NSError **)error;
- (NSArray*)findDirtyEntities:(NSString*)entityName error:(NSError**)error;
- (NSArray*)findAllEntities:(NSString*)entityName error:(NSError**)error;
- (NSArray*)findAllEntities:(NSString*)entityName predicate:(NSPredicate*)predicate error:(NSError**)error;
@end