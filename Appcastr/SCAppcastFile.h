//
//  SCAppcastFile.h
//  Appcastr
//
//  Created by Alex Jackson on 13/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCAppcastItem.h"

@class SCDocument;

@interface SCAppcastFile : NSObject

@property (weak) SCDocument *currentDoc;

@property (copy) NSMutableArray *items; 
@property (strong) NSMutableString *appcastDescription;
@property (strong) NSMutableString *appcastTitle;
@property (strong) NSMutableString *appcastLink;
@property (strong) NSMutableString *appcastLanguage;

- (void)insertObject:(SCAppcastItem *)object inItemsAtIndex:(NSUInteger)index;
- (void)removeObjectFromItemsAtIndex:(NSUInteger)index;

@end
