//
//  CoreDataModelManager.h
//  spending
//
//  Created by Riley Crebs on 4/7/14.
//  Copyright (c) 2014 Riley Crebs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CoreDataSession;
@class NSManagedObjectModel;

extern NSString* const CoreDataControllerDidSaveNotification;
extern NSString* const CoreDataStoreDidImportUbiquitousContentChanges;

@interface CoreDataModelManager : NSObject

@property (strong,readonly,nonatomic) NSURL* storeURL;
@property (strong,readonly,nonatomic) NSManagedObjectModel* mom;

/* @brief need to set the store name for core data stack to build correctly.
 * @param name Name to give to the data store
 */
+ (void)setDefaultStoreName:(NSString*)name;

/* @brief Need to set the name of the .mom file for core data stack to build correclty
 * @param name Name of the MOM file.
 */
+ (void)setDefaultMOMName:(NSString*)name;

+ (CoreDataSession*)newSession;
+ (CoreDataSession*)mainSession;

// Migration
+ (BOOL)migrate:(NSError *__autoreleasing *)error;
+ (BOOL)isMigrationNeeded;
@end
