//
//  NSString+Extension.h
//  spending
//
//  Created by Riley Crebs on 10/6/13.
//  Copyright (c) 2013 Riley Crebs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
- (NSString*) sanatizedFileName;
- (BOOL) contains:(NSString*)str;
+(NSString *)GUID;
@end
