//
//  SCAppcastFile.m
//  Appcastr
//
//  Created by Alex Jackson on 13/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SCAppcastFile.h"

@implementation SCAppcastFile

@synthesize appcastLink, appcastTitle, appcastLanguage, appcastDescription, items;

- (id)init{
    self = [super init];
    
    if(self){
        appcastTitle = [[NSString alloc] init];
        appcastLink = [[NSString alloc] init];
        appcastLanguage = [[NSString alloc] init];
        appcastDescription = [[NSString alloc] init];
        
        items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)insertObject:(SCAppcastItem *)object inItemsAtIndex:(NSUInteger)index{
    NSUndoManager *undo = [[[NSDocumentController sharedDocumentController] currentDocument] undoManager];
    [[undo prepareWithInvocationTarget:self] removeObjectFromItemsAtIndex:index];
    [items insertObject:object atIndex:index];
}

- (void)removeObjectFromItemsAtIndex:(NSUInteger)index{
    SCAppcastItem *appcastItem = [self.items objectAtIndex:index];
    NSUndoManager *undo = [[[NSDocumentController sharedDocumentController] currentDocument] undoManager];
    [[undo prepareWithInvocationTarget:self] insertObject:appcastItem inItemsAtIndex:index];
    [items removeObjectAtIndex:index];
}

@end
