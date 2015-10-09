//
//  ModelManager.h
//  spending
//
//  Created by Riley Crebs on 4/7/14.
//  Copyright (c) 2014 Riley Crebs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSManagedObject+Extension.h"

@interface ModelManager : NSObject

- (NSManagedObjectContext*) context;

// Core Data
- (id)initWithNewSession;
- (id)initWithMainSession;
- (BOOL)commit:(NSError**)error;
- (void) delete:(NSManagedObject*)object;

// Migration
+ (BOOL)isMigrationNeeded;
+ (BOOL)migrate:(NSError *__autoreleasing *)error;

- (NSArray*)findOrCreateEntity:(NSString*)entityName entityIdName:(NSString*)entityIdName entityIds:(NSArray*)entities;
- (void)deleteEntity:(NSString*)entityName entityIdName:(NSString*)entityIdName entityIds:(NSArray*)entities;
- (NSArray*)findDirtyEntities:(NSString*)entityName;
- (NSArray*)findAllEntities:(NSString*)entityName;
- (NSArray*)findAllEntities:(NSString*)entityName predicate:(NSPredicate*)predicate;
@end
