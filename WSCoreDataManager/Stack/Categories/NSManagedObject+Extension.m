//
//  NSManagedObject+Extention.m
//  spending
//
//  Created by Lindsay Crebs on 5/23/13.
//  Copyright (c) 2013 Riley Crebs. All rights reserved.
//

#import "NSManagedObject+Extension.h"

@implementation NSManagedObject (Extension)

- (void) deepCopy:(NSManagedObject*)objectToCopy
{
    @throw  [NSException exceptionWithName:@"NSManagedObject+Extention objectToCopy:" reason:[NSString stringWithFormat:@"%@ needs to implement objectToCopy: in a category.", NSStringFromClass([self class])] userInfo:nil];
}

- (NSManagedObject*) copyInContext:(NSManagedObjectContext*)context
{
    @throw  [NSException exceptionWithName:@"NSManagedObject+Extention deepCopyOfObject:inContext:" reason:[NSString stringWithFormat:@"%@ needs to implement deepCopyOfObject:inContext: in a category.", NSStringFromClass([self class])] userInfo:nil];
}
@end
