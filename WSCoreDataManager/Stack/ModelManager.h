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

/* @brief need to set the store name for core data stack to build correctly.
 * @param name Name to give to the data store
 */
+ (void)setDefaultStoreName:(NSString*)name;

/* @brief Need to set the name of the .mom file for core data stack to build correclty
 * @param name Name of the MOM file.
 */
+ (void)setDefaultMOMName:(NSString*)name;

- (NSArray*)findOrCreateEntity:(NSString*)entityName entityIdName:(NSString*)entityIdName entityIds:(NSArray*)entities;
- (void)deleteEntity:(NSString*)entityName entityIdName:(NSString*)entityIdName entityIds:(NSArray*)entities;
- (NSArray*)findDirtyEntities:(NSString*)entityName;
- (NSArray*)findAllEntities:(NSString*)entityName;
- (NSArray*)findAllEntities:(NSString*)entityName predicate:(NSPredicate*)predicate;
@end
