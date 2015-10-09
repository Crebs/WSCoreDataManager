//
//  NSManagedObject+Extention.h
//  spending
//
//  Created by Lindsay Crebs on 5/23/13.
//  Copyright (c) 2013 Riley Crebs. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Extension)
- (void) deepCopy:(NSManagedObject*)objectToCopy;
- (NSManagedObject*) copyInContext:(NSManagedObjectContext*)context;
@end
