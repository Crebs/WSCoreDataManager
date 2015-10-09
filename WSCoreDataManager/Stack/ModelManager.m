//
//  ModelManager.m
//  spending
//
//  Created by Riley Crebs on 4/7/14.
//  Copyright (c) 2014 Riley Crebs. All rights reserved.
//

#import "ModelManager.h"

#import "CoreDataModelManager.h"
#import "CoreDataSession.h"
#import "NSManagedObject+Incravo.h"

@interface ModelManager ()
@property (strong,nonatomic) CoreDataSession* cdSession;
@end

@implementation ModelManager

- (id)initWithNewSession {
    if (self = [super init]) {
        _cdSession = [CoreDataModelManager newSession];
    }
    return self;
}

- (id)initWithMainSession {
    if (self = [super init]) {
        _cdSession = [CoreDataModelManager mainSession];
    }
    return self;
}

#pragma mark - Core Data
- (BOOL)commit:(NSError**)error {
    BOOL commitedSuccessfully = YES;
    if (![self.cdSession.context save:error]) {
        NSAssert(error, @"Error when saving context");
        commitedSuccessfully = NO;
    };
    return commitedSuccessfully;
}

- (void) delete:(NSManagedObject*)object
{
    if (object) {
        [[self context] deleteObject:object];
    }
}

#pragma mark - Migration
+ (BOOL)migrate:(NSError *__autoreleasing *)error
{
//    [CoreDataModelManager reset];
    BOOL migreated = [CoreDataModelManager migrate:error];
    
    return migreated;
}

+ (BOOL)isMigrationNeeded
{
    return [CoreDataModelManager isMigrationNeeded];
}

- (NSManagedObjectContext*)context {
    return self.cdSession.context;
}

#pragma mark - Find or create
- (NSArray*)findOrCreateEntity:(NSString*)entityName entityIdName:(NSString*)entityIdName entityIds:(NSArray*)entities {
    NSError* error = nil;
    NSArray* allEntities = [self.cdSession findOrCreateEntity:entityName entityId:entityIdName entityIds:entities error:&error];
    if (error) {
    }
    return allEntities;
}

- (NSArray*)findDirtyEntities:(NSString*)entityName {
    NSError* error = nil;
    NSArray* entities = [self.cdSession findDirtyEntities:entityName error:&error];
    if (error) {
    }
    return entities;
}

- (NSArray*)findAllEntities:(NSString*)entityName {
    NSError* error = nil;
    NSArray* entities = [self.cdSession findAllEntities:entityName error:&error];
    if (error) {
    }
    return entities;
}

- (NSArray*)findAllEntities:(NSString*)entityName predicate:(NSPredicate*)predicate {
    NSError* error = nil;
    NSArray* entities = [self.cdSession findAllEntities:entityName predicate:predicate error:&error];
    if (error) {
    }
    return entities;
}

- (void)deleteEntity:(NSString*)entityName entityIdName:(NSString*)entityIdName entityIds:(NSArray*)entities {
    NSError* error = nil;
    NSArray* entitiesToDelete = [self.cdSession findEntity:entityName entityIds:entities entityId:entityIdName error:&error];
    if (!error) {
        for (NSManagedObject* entity in entitiesToDelete) {
            [entity deleteObject];
        }
    }
    
}

@end
