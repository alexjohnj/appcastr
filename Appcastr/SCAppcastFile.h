//
//  SCAppcastFile.h
//  Appcastr
//
//  Created by Alex Jackson on 13/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCAppcastItem.h"

@interface SCAppcastFile : NSObject

@property (copy) NSMutableArray *items; 
@property (strong) NSString *appcastDescription;
@property (strong) NSString *appcastTitle;
@property (strong) NSString *appcastLink;
@property (strong) NSString *appcastLanguage;

- (void)insertObject:(SCAppcastItem *)object inItemsAtIndex:(NSUInteger)index;
- (void)removeObjectFromItemsAtIndex:(NSUInteger)index;

@end
