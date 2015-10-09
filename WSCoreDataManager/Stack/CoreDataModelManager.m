//
//  CoreDataModelManager.m
//  spending
//
//  Created by Riley Crebs on 4/7/14.
//  Copyright (c) 2014 Riley Crebs. All rights reserved.
//

#import "CoreDataModelManager.h"

#import "CoreDataSession.h"
#import "MHWMigrationManager.h"
#import "NSFileManager+Extension.h"

@import CoreData;
@import UIKit;

static id defualtStoreName = nil;
static id defualtMOMName = nil;

NSString* const CoreDataControllerDidSaveNotification = @"CoreDataControllerDidSaveNotification";
NSString* const CoreDataStoreDidImportUbiquitousContentChanges = @"CoreDataStoreDidImportUbiquitousContentChanges";

@interface CoreDataModelManager () <MHWMigrationManagerDelegate>
@property (strong,nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong,nonatomic) NSPersistentStore *persistentStore;
@property (strong,nonatomic) NSURL* storeURL;
@property (strong,nonatomic) CoreDataSession* mainSession;
@end

@implementation CoreDataModelManager

@synthesize mom = _mom;

#pragma mark - Life Cycle
+ (id) sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Session
- (CoreDataSession*)mainSession {
    if (!_mainSession) {
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(contextDidSave:)
                   name:NSManagedObjectContextDidSaveNotification
                 object:nil];
        NSPersistentStoreCoordinator *coordinator = [[CoreDataModelManager sharedInstance] persistentStoreCoordinator];
        _mainSession = [[CoreDataSession alloc] initWithPersistentStoreCoordinator:coordinator concurrencyType:NSMainQueueConcurrencyType];
    }
    return _mainSession;
}

+ (CoreDataSession*)mainSession {
    return [[CoreDataModelManager sharedInstance] mainSession];
}

+ (CoreDataSession*)newSession {
    NSPersistentStoreCoordinator *coordinator = [[CoreDataModelManager sharedInstance] persistentStoreCoordinator];
    return [[CoreDataSession alloc] initWithPersistentStoreCoordinator:coordinator concurrencyType:NSPrivateQueueConcurrencyType];
}

+ (void)setDefaultStoreName:(NSString*)name {
    defualtStoreName = name;
}

+ (void)setDefaultMOMName:(NSString*)name {
    defualtMOMName = name;
}

// Called my Notification center when contexts have been saved.
- (void)contextDidSave:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mainSession.context performBlockAndWait:^{
            [self.mainSession.context mergeChangesFromContextDidSaveNotification:notification];
            [[NSNotificationCenter defaultCenter] postNotificationName:CoreDataControllerDidSaveNotification object:nil userInfo:[notification userInfo]];
        }];
    });
}

#pragma mark -
- (NSURL*)storeURL {
    if (!_storeURL) {
        _storeURL = [[NSFileManager applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", defualtStoreName]];
    }
    return _storeURL;
}

+ (NSPersistentStoreCoordinator*)storeCoordinator {
    return [[CoreDataModelManager sharedInstance] persistentStoreCoordinator];
}

- (NSManagedObjectModel *)mom {
    if (_mom != nil) {
        return _mom;
    }
    __block NSURL *modelURL = nil;
    [[NSBundle allBundles]  enumerateObjectsUsingBlock:^(NSBundle * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        modelURL = [obj URLForResource:defualtMOMName withExtension:@"momd"];
        *stop = (modelURL != nil);
    }];
    _mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _mom;
}

- (NSPersistentStore*)configureLocalPersistentStoreCoordinator:(NSDictionary *)options withStoreURL:(NSURL*)url {
    __block NSError* error = nil;
    __block NSPersistentStore *persistentStore = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self mom]];
    [_persistentStoreCoordinator performBlockAndWait:^{
        persistentStore = [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                        configuration:nil
                                                                                  URL:url
                                                                              options:options
                                                                                error:&error];
    }];
    return persistentStore;
}

- (void) setUpLocalStore {
	NSDictionary *options = @{
							  NSPersistentStoreUbiquitousContentNameKey: defualtStoreName
							  };
    self.persistentStore = [self configureLocalPersistentStoreCoordinator:options withStoreURL:self.storeURL];
}

- (BOOL) loadPersistentStore {
    [self setUpLocalStore];
    
    return YES;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator == nil) {
        [self loadPersistentStore];
    }
    
    return _persistentStoreCoordinator;
}

- (NSDictionary *)sourceMetadata:(NSError **)error {
    NSURL* url = [NSFileManager coreDataUbiquityStoreURL];
    if (!url) {
        url = [[CoreDataModelManager sharedInstance] storeURL];
    }
    return [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType
                                                                      URL:url
                                                                    error:error];
}

#pragma mark - Migration
+ (BOOL)migrate:(NSError *__autoreleasing *)error {
    // Enable migrations to run even while user exits app
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    MHWMigrationManager *migrationManager = [MHWMigrationManager new];
    migrationManager.delegate = [CoreDataModelManager sharedInstance];
    
    NSURL* url = [NSFileManager coreDataUbiquityStoreURL];
    if (!url) {
        url = [[CoreDataModelManager sharedInstance] storeURL];
    }
    BOOL OK = [migrationManager progressivelyMigrateURL:url
                                                 ofType:NSSQLiteStoreType
                                                toModel:[[CoreDataModelManager sharedInstance] mom]
                                                  error:error];
//    if (OK) {
//        DDLogVerbose(@"migration complete");
//    }
    
    // Mark it as invalid
    [[UIApplication sharedApplication] endBackgroundTask:bgTask];
    bgTask = UIBackgroundTaskInvalid;
    
    return OK;
}

+ (BOOL)isMigrationNeeded {
    NSError *error = nil;
    // Check if we need to migrate
    NSDictionary *sourceMetadata = [[CoreDataModelManager sharedInstance] sourceMetadata:&error];
    BOOL isMigrationNeeded = NO;
    
    if (sourceMetadata != nil) {
        NSManagedObjectModel *destinationModel = [[CoreDataModelManager sharedInstance] mom];
        // Migration is needed if destinationModel is NOT compatible
        isMigrationNeeded = ![destinationModel isConfiguration:nil
                                   compatibleWithStoreMetadata:sourceMetadata];
    }
//    DDLogVerbose(@"isMigrationNeeded: %d", isMigrationNeeded);
    return isMigrationNeeded;
}
@end
