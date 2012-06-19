//
//  SCDocument.m
//  Appcastr
//
//  Created by Alex Jackson on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SCDocument.h"

@implementation SCDocument
@synthesize minimumVersionBox;
@synthesize updateTitleField, updateBuildNumberField, updateVersionNumberField, updateDownloadLinkField, updateReleaseNotesDownloadLinkField, updateSignatureField, updateSizeField, updatePublicationDatePicker, sideBarTable;
@synthesize appcastFile = _appcastFile, appcastUpdatesArrayController;
@synthesize advancedUpdateSettingsSheet = _advancedUpdateSettingsSheet;

- (id)init
{
    self = [super init];
    if (self) {
        _appcastFile = [[SCAppcastFile alloc] init];
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
    
    NSUInteger arrayControllerCount = [(NSArray *)[self.appcastUpdatesArrayController content] count];
    if(arrayControllerCount > 0)
        [self.sideBarTable selectRowIndexes:[NSIndexSet indexSetWithIndex:self.appcastUpdatesArrayController.selectionIndex] 
                       byExtendingSelection:NO];
    
    if ([self isInViewingMode]) { // this body of code is used to configure the old windows being shown in the versions browser
        [self makeUserInterfaceInteractive:NO forDocument:(SCDocument *)[aController document]]; // it just makes sure that you can't edit their contents
    }
    
    NSArray *comboArray = [NSArray arrayWithObjects:@"10.6.0", @"10.6.1", @"10.6.2", @"10.6.3", nil];
    [self.minimumVersionBox addItemsWithObjectValues:comboArray];
}

#pragma mark - Data Saving/Loading

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (BOOL)prepareSavePanel:(NSSavePanel *)savePanel{
    [savePanel setExtensionHidden:NO];
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
    SCAppcastWriter *appcastCreator = [[SCAppcastWriter alloc] init];
    NSXMLDocument *appcastXMLDocument = [appcastCreator prepareXMLDocumentFromAppcastData:self.appcastFile];
    
    NSData *appcastFileDataRepresentation = [appcastXMLDocument XMLDataWithOptions:NSXMLNodePrettyPrint];
    
    return appcastFileDataRepresentation;
}

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{    
    NSXMLDocument *appcastXMLDocument = [[NSXMLDocument alloc] initWithContentsOfURL:url 
                                                                             options:NSXMLDocumentTidyXML error:nil];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[appcastXMLDocument XMLData]];
    SCXMLParserDelegate *xmlParserDelegate = [[SCXMLParserDelegate alloc] init];
    
    [xmlParser setDelegate:xmlParserDelegate];
    
    BOOL parseSuccesful = [xmlParser parse];
    
    if(!parseSuccesful){
        if(outError != NULL)
            *outError = [xmlParser parserError];
        return NO;
    }
    
    else{
        self.appcastFile = xmlParserDelegate.appcastFileRepresentation;
        [self startObservingAppcastFile:self.appcastFile];
        return YES;
    }
}

- (BOOL)revertToContentsOfURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
    [self stopObservingAppcastFile:self.appcastFile];
    
    return [super revertToContentsOfURL:url ofType:typeName error:outError];
} 

#pragma mark - Versions Customisation

- (void)windowWillEnterVersionBrowser:(NSNotification *)notification{
    [self makeUserInterfaceInteractive:NO forDocument:self];
}

- (void)windowDidExitVersionBrowser:(NSNotification *)notification{
    [self makeUserInterfaceInteractive:YES forDocument:self];
}

- (void)makeUserInterfaceInteractive:(BOOL)editable forDocument:(SCDocument *)document{
    if(document.isInViewingMode){
        [document.updateTitleField setEditable:editable];
        [document.updateBuildNumberField setEditable:editable];
        [document.updateVersionNumberField setEditable:editable];
        [document.updateDownloadLinkField setEditable:editable];
        [document.updateReleaseNotesDownloadLinkField setEditable:editable];
        [document.updateSignatureField setEditable:editable];
        [document.updateSizeField setEditable:editable];
        [document.updatePublicationDatePicker setEnabled:editable]; // Haha, this doesn't make much sense with the editable argument. 
    }
}

#pragma mark - Window Restoration

- (void)window:(NSWindow *)window willEncodeRestorableState:(NSCoder *)state{
}

- (void)window:(NSWindow *)window didDecodeRestorableState:(NSCoder *)state{
}

#pragma mark - Update Array Insertation Methods

- (IBAction)createNewUpdate:(id)sender{
    SCAppcastItem *newUpdate = [self.appcastUpdatesArrayController newObject];
    [self.appcastUpdatesArrayController addObject:newUpdate];
}

- (IBAction)deleteOldUpdate:(id)sender{
    [self.appcastUpdatesArrayController removeObjectAtArrangedObjectIndex:self.appcastUpdatesArrayController.selectionIndex];
}

# pragma mark - UI Actions

- (IBAction)showAppcastSettingsPopover:(id)sender{
    NSPopover *pops = [[NSPopover alloc] init];
    pops.contentViewController = [[SCAppcastSettingsPopoverViewController alloc] initWithNibName:@"SCAppcastSettingsPopoverView" 
                                                                                          bundle:nil];
    pops.contentViewController.representedObject = self.appcastFile;
    pops.behavior = NSPopoverBehaviorTransient;
    
    [pops showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinYEdge];
}

- (IBAction)showAdvancedUpdateSettingsSheet:(id)sender{
    if(_advancedUpdateSettingsSheet)
        _advancedUpdateSettingsSheet = nil;
    
    SCAppcastItem *currentlySelectedItem = self.appcastUpdatesArrayController.selection;
    _advancedUpdateSettingsSheet = [[SCAdvancedUpdateInformationSheetController alloc] initWithWindowNibName:@"SCAdvancedUpdateInformationSheet"
                                                                                             appcastUpdate:currentlySelectedItem];
    [NSApp beginSheet:self.advancedUpdateSettingsSheet.window
       modalForWindow:[self windowForSheet]
        modalDelegate:self
       didEndSelector:@selector(sheetDidEnd:resultCode:contextInfo:)
          contextInfo:NULL];
}

#pragma mark - Undo Methods
- (void)startObservingAppcastFile:(SCAppcastFile *)file{
    [file addObserver:self forKeyPath:@"appcastTitle" options:NSKeyValueObservingOptionOld context:NULL];
    [file addObserver:self forKeyPath:@"appcastLanguage" options:NSKeyValueObservingOptionOld context:NULL];
    [file addObserver:self forKeyPath:@"appcastLink" options:NSKeyValueObservingOptionOld context:NULL];
    [file addObserver:self forKeyPath:@"appcastDescription" options:NSKeyValueObservingOptionOld context:NULL];
    
    for(SCAppcastItem *update in file.items){
        [self startObservingUpdateInformation:update];
    }
}

- (void)stopObservingAppcastFile:(SCAppcastFile *)file{
    [file removeObserver:self forKeyPath:@"appcastTitle"];
    [file removeObserver:self forKeyPath:@"appcastLanguage"];
    [file removeObserver:self forKeyPath:@"appcastLink"];
    [file removeObserver:self forKeyPath:@"appcastDescription"];
    
    for(SCAppcastItem *update in file.items){
        [self stopObservingUpdateInformation:update];
    }
}

- (void)startObservingUpdateInformation:(SCAppcastItem *)model{ 
    [model addObserver:self forKeyPath:@"updateBuildNumber" options:NSKeyValueObservingOptionOld context:NULL];
    [model addObserver:self forKeyPath:@"updateHumanReadableVersionNumber" options:NSKeyValueObservingOptionOld context:NULL];
    [model addObserver:self forKeyPath:@"updateSignature" options:NSKeyValueObservingOptionOld context:NULL];
    [model addObserver:self forKeyPath:@"updateDownloadLink" options:NSKeyValueObservingOptionOld context:NULL];
    [model addObserver:self forKeyPath:@"updateReleaseNotesLink" options:NSKeyValueObservingOptionOld context:NULL];
    [model addObserver:self forKeyPath:@"updateTitle" options:NSKeyValueObservingOptionOld context:NULL];
    [model addObserver:self forKeyPath:@"updateLength" options:NSKeyValueObservingOptionOld context:NULL];
    [model addObserver:self forKeyPath:@"updateMimeType" options:NSKeyValueObservingOptionOld context:NULL];
    [model addObserver:self forKeyPath:@"updatePublicationDate" options:NSKeyValueObservingOptionOld context:NULL];
    [model addObserver:self forKeyPath:@"updateMinimumSystemVersion" options:NSKeyValueObservingOptionOld context:NULL];
    [model addObserver:self forKeyPath:@"updateMaximumSystemVersion" options:NSKeyValueObservingOptionOld context:NULL];
    [model addObserver:self forKeyPath:@"updateSpecifiesMinimumSystemVersion" options:NSKeyValueObservingOptionOld context:NULL];
    [model addObserver:self forKeyPath:@"updateSpecifiesMaximumSystemVersion" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void)stopObservingUpdateInformation:(SCAppcastItem *)model{
    [model removeObserver:self forKeyPath:@"updateBuildNumber"];
    [model removeObserver:self forKeyPath:@"updateHumanReadableVersionNumber"];
    [model removeObserver:self forKeyPath:@"updateSignature"];
    [model removeObserver:self forKeyPath:@"updateDownloadLink"];
    [model removeObserver:self forKeyPath:@"updateReleaseNotesLink"];
    [model removeObserver:self forKeyPath:@"updateTitle"];
    [model removeObserver:self forKeyPath:@"updateLength"];
    [model removeObserver:self forKeyPath:@"updateMimeType"];
    [model removeObserver:self forKeyPath:@"updatePublicationDate"];
    [model removeObserver:self forKeyPath:@"updateMinimumSystemVersion"];
    [model removeObserver:self forKeyPath:@"updateMaximumSystemVersion"];
    [model removeObserver:self forKeyPath:@"updateSpecifiesMinimumSystemVersion"];
    [model removeObserver:self forKeyPath:@"updateSpecifiesMaximumSystemVersion"];
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
    [self stopObservingAppcastFile:self.appcastFile];
} 

- (void)sheetDidEnd:(NSWindow *)sheet resultCode:(NSInteger)resultCode contextInfo:(void *)contextInfo {
    if(sheet == self.advancedUpdateSettingsSheet.window){
        [sheet orderOut:self];
        self.advancedUpdateSettingsSheet = nil;
    }
}

@end
