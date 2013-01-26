//
//  SCAppcastFile.m
//  Appcastr
//
//  Created by Alex Jackson on 13/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SCAppcastFile.h"
#import "SCDocument.h"

@implementation SCAppcastFile

- (id)init{
    self = [super init];
    
    if(self){
        _appcastTitle = [[NSMutableString alloc] init];
        _appcastLink = [[NSMutableString alloc] init];
        _appcastLanguage = [[NSMutableString alloc] init];
        _appcastDescription = [[NSMutableString alloc] init];
        
        _items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)insertObject:(SCAppcastItem *)object inItemsAtIndex:(NSUInteger)index{
    NSUndoManager *undo = [[[NSDocumentController sharedDocumentController] currentDocument] undoManager];
    [[undo prepareWithInvocationTarget:self] removeObjectFromItemsAtIndex:index];
    [self.items insertObject:object atIndex:index];
    [[[NSDocumentController sharedDocumentController] currentDocument] startObservingUpdateInformation:object];
}

- (void)removeObjectFromItemsAtIndex:(NSUInteger)index{
    SCAppcastItem *appcastItem = (self.items)[index];
    NSUndoManager *undo = [[[NSDocumentController sharedDocumentController] currentDocument] undoManager];
    [[undo prepareWithInvocationTarget:self] insertObject:appcastItem inItemsAtIndex:index];
    [self.items removeObjectAtIndex:index];
    [[[NSDocumentController sharedDocumentController] currentDocument] stopObservingUpdateInformation:appcastItem];
}

@end
