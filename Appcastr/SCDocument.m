//
//  SCDocument.m
//  Appcastr
//
//  Created by Alex Jackson on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SCDocument.h"

@implementation SCDocument
@synthesize appcastData, appcastConfigurationSheet;

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"SCDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
    SCAppcastWriter *appcastCreator = [[SCAppcastWriter alloc] init];
    NSXMLDocument *appcastFile = [appcastCreator prepareXMLDocumentFromAppCastData:self.appcastData];
    
    NSData *appcastFileDataRepresentation = [appcastFile XMLDataWithOptions:NSXMLNodePrettyPrint];
    
    return appcastFileDataRepresentation;
}

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
    NSXMLDocument *appcastFile = [[NSXMLDocument alloc] initWithContentsOfURL:url options:NSXMLDocumentTidyXML error:nil];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[appcastFile XMLData]];
    SCXMLParserDelegate *xmlParserDelegate = [[SCXMLParserDelegate alloc] init];
    
    [xmlParser setDelegate:xmlParserDelegate];
    
    BOOL parseSuccesful = [xmlParser parse];
    
    if(!parseSuccesful){
        *outError = [xmlParser parserError];
        return NO;
    }
    
    else{
        appcastData = xmlParserDelegate.appcastData;
        [self startObservingAppcastModel:self.appcastData];
        return YES;
    }
    
}

- (IBAction)showAppcastConfigurationSheet:(id)sender{
    if(self.appcastConfigurationSheet)
        self.appcastConfigurationSheet = nil;
    
    appcastConfigurationSheet = [[SCAppcastConfigurationWindowController alloc] initWithWindowNibName:@"SCAppcastConfigurationSheet" appcastData:self.appcastData];
    
    [NSApp beginSheet:self.appcastConfigurationSheet.window
       modalForWindow:self.windowForSheet
        modalDelegate:self
       didEndSelector:@selector(sheetDidEnd:resultCode:contextInfo:)
          contextInfo:NULL];
}

- (void)sheetDidEnd:(NSWindow *)sheet resultCode:(NSInteger)resultCode contextInfo:(void *)contextInfo {
    if(sheet == self.appcastConfigurationSheet.window){
        self.appcastData = self.appcastConfigurationSheet.appcastData;
        [sheet orderOut:self];
    }
}

#pragma mark - Undo Methods

- (void)startObservingAppcastModel:(SCAppcastModel *)model{
    [model addObserver:self forKeyPath:@"updateBuildNumber" options:NSKeyValueObservingOptionOld context:NULL];
    [model addObserver:self forKeyPath:@"updateHumanReadableVersionNumber" options:NSKeyValueObservingOptionOld context:NULL];
    [model addObserver:self forKeyPath:@"updateSignature" options:NSKeyValueObservingOptionOld context:NULL];
    [model addObserver:self forKeyPath:@"updateDownloadLink" options:NSKeyValueObservingOptionOld context:NULL];
    [model addObserver:self forKeyPath:@"updateReleaseNotesLink" options:NSKeyValueObservingOptionOld context:NULL];
    [model addObserver:self forKeyPath:@"updateTitle" options:NSKeyValueObservingOptionOld context:NULL];
    [model addObserver:self forKeyPath:@"updateLength" options:NSKeyValueObservingOptionOld context:NULL];
    [model addObserver:self forKeyPath:@"updateMimeType" options:NSKeyValueObservingOptionOld context:NULL];
    [model addObserver:self forKeyPath:@"updatePublicationDate" options:NSKeyValueObservingOptionOld context:NULL];
    
    [model addObserver:self forKeyPath:@"appCastDescription" options:NSKeyValueObservingOptionOld context:NULL];
    [model addObserver:self forKeyPath:@"appCastTitle" options:NSKeyValueObservingOptionOld context:NULL];
    [model addObserver:self forKeyPath:@"appCastLink" options:NSKeyValueObservingOptionOld context:NULL];
    [model addObserver:self forKeyPath:@"appCastLanguage" options:NSKeyValueObservingOptionOld context:NULL];

}

- (void)stopObservingAppcastModel:(SCAppcastModel *)model{
    [model removeObserver:self forKeyPath:@"updateBuildNumber"];
    [model removeObserver:self forKeyPath:@"updateHumanReadableVersionNumber"];
    [model removeObserver:self forKeyPath:@"updateSignature"];
    [model removeObserver:self forKeyPath:@"updateDownloadLink"];
    [model removeObserver:self forKeyPath:@"updateReleaseNotesLink"];
    [model removeObserver:self forKeyPath:@"updateTitle"];
    [model removeObserver:self forKeyPath:@"updateLength"];
    [model removeObserver:self forKeyPath:@"updateMimeType"];
    [model removeObserver:self forKeyPath:@"updatePublicationDate"];
    
    [model removeObserver:self forKeyPath:@"appCastDescription"];
    [model removeObserver:self forKeyPath:@"appCastTitle"];
    [model removeObserver:self forKeyPath:@"appCastLink"];
    [model removeObserver:self forKeyPath:@"appCastLanguage"];
}

-(void)changeKeyPath:(NSString *)keyPath ofObject:(id)obj toValue:(id)newValue{
    [obj setValue:newValue forKeyPath:keyPath];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSUndoManager *undo = [self undoManager];
    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    [[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath ofObject:object toValue:oldValue];
    [undo setActionName:@"Edit"];
}

- (void)dealloc{
    [self stopObservingAppcastModel:self.appcastData];
}

@end
