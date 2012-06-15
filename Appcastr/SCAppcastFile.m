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

@synthesize appcastLink = _appcastLink, appcastTitle = _appcastTitle, appcastLanguage = _appcastLanguage, appcastDescription = _appcastDescription, items = _items;
@synthesize currentDoc = _currentDoc;

- (id)init{
    self = [super init];
    
    if(self){
        _appcastTitle = [[NSString alloc] init];
        _appcastLink = [[NSString alloc] init];
        _appcastLanguage = [[NSString alloc] init];
        _appcastDescription = [[NSString alloc] init];
        
        _items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)insertObject:(SCAppcastItem *)object inItemsAtIndex:(NSUInteger)index{
    NSUndoManager *undo = [[[NSDocumentController sharedDocumentController] currentDocument] undoManager];
    [[undo prepareWithInvocationTarget:self] removeObjectFromItemsAtIndex:index];
    [_items insertObject:object atIndex:index];
    [[[NSDocumentController sharedDocumentController] currentDocument] startObservingUpdateInformation:object];
}

- (void)removeObjectFromItemsAtIndex:(NSUInteger)index{
    SCAppcastItem *appcastItem = [self.items objectAtIndex:index];
    NSUndoManager *undo = [[[NSDocumentController sharedDocumentController] currentDocument] undoManager];
    [[undo prepareWithInvocationTarget:self] insertObject:appcastItem inItemsAtIndex:index];
    [_items removeObjectAtIndex:index];
    [[[NSDocumentController sharedDocumentController] currentDocument] stopObservingUpdateInformation:appcastItem];
}

@end
