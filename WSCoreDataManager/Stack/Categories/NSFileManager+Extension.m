//
//  NSFileManager+Extension.m
//  spending
//
//  Created by Riley Crebs on 4/7/14.
//  Copyright (c) 2014 Riley Crebs. All rights reserved.
//

#import "NSFileManager+Extension.h"

#import "NSString+Extension.h"

@implementation NSFileManager (Extension)

+ (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSString*)coreDataUbiquitySupportDirectoryAbsoluteString {
    NSString* filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/CoreDataUbiquitySupport"];
    return filePath;//[NSURL URLWithString:filePath];
}

+ (NSURL*)coreDataUbiquityStoreURL {
    NSString* ubiquityRootDirectory = [NSFileManager coreDataUbiquitySupportDirectoryAbsoluteString];
    NSFileManager* fm = [NSFileManager new];
    NSDirectoryEnumerator* dirEnum = [fm enumeratorAtPath:ubiquityRootDirectory];
    NSString* file = nil;
    NSURL* url = nil;
    while (file = [dirEnum nextObject]) {
        if ([file contains:@"sqlite"]) {
            NSString* storeURL = [ubiquityRootDirectory stringByAppendingPathComponent:file];
            url = [NSURL fileURLWithPath:storeURL];
            break;
        }
    }
    return url;
}
@end
