//
//  NSFileManager+Extension.h
//  spending
//
//  Created by Riley Crebs on 4/7/14.
//  Copyright (c) 2014 Riley Crebs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Extension)

+ (NSURL *)applicationDocumentsDirectory;
+ (NSURL*)coreDataUbiquityStoreURL;
@end
