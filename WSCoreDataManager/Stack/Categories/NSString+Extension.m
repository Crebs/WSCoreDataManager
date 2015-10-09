//
//  NSString+Extension.m
//  spending
//
//  Created by Riley Crebs on 10/6/13.
//  Copyright (c) 2013 Riley Crebs. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
- (BOOL) contains:(NSString*)str
{
	NSRange range = [self rangeOfString:str options:NSCaseInsensitiveSearch];
	
	return (range.location != NSNotFound && range.length != 0);
}

- (NSString*) sanatizedFileName
{
	NSString* sanatizedName = [self copy];
	NSCharacterSet* illegalFileNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"x/\\?%*|\"<>"];
	sanatizedName = [[sanatizedName componentsSeparatedByCharactersInSet:illegalFileNameCharacters] componentsJoinedByString:@"_"];
	sanatizedName = [sanatizedName substringToIndex:MIN(sanatizedName.length, NAME_MAX)];
	return sanatizedName;
}

+(NSString *)GUID
{
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    NSString * uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    CFRelease(newUniqueId);
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm:ss"];
	//Optionally for time zone converstions
	[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
	NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
	
    return [NSString stringWithFormat:@"%@+%@", stringFromDate, uuidString];
}
@end
