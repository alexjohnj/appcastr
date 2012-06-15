//
//  SCDocument.m
//  Appcastr
//
//  Created by Alex Jackson on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SCDocument.h"

@implementation SCDocument
@synthesize updateTitleField, updateBuildNumberField, updateVersionNumberField, updateDownloadLinkField, updateReleaseNotesDownloadLinkField, updateSignatureField, updateSizeField, updatePublicationDatePicker, appcastNameField, appcastLinkField, appcastLanguageField, appcastDescriptionField;
@synthesize appcastFile, appcastUpdatesArrayController;
@synthesize appcastSettingsBox;

- (id)init
{
    self = [super init];
    if (self) {
        appcastFile = [[SCAppcastFile alloc] init];
        for(int i = 0; i < self.appcastFile.items.count; i++){
            [self startObservingUpdateInformation:[self.appcastFile.items objectAtIndex:i]];
        }
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
    
    if ([self isInViewingMode]) { // this body of code is used to configure the old windows being shown in the versions browser
        [self makeUserInterfaceInteractive:NO forDocument:(SCDocument *)[aController document]]; // it just makes sure that you can't edit their contents
    }
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
    for(int i = 0; i<self.appcastFile.items.count;i++){
        [self stopObservingUpdateInformation:[self.appcastFile.items objectAtIndex:i]];
    }
    NSXMLDocument *appcastXMLDocument = [[NSXMLDocument alloc] initWithContentsOfURL:url options:NSXMLDocumentTidyXML error:nil];
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
        for(int i = 0; i<self.appcastFile.items.count;i++){
            [self startObservingUpdateInformation:[self.appcastFile.items objectAtIndex:i]];
        }
        return YES;
    }
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
        
        [document.appcastNameField setEditable:editable];
        [document.appcastLinkField setEditable:editable];
        [document.appcastLanguageField setEditable:editable];
        [document.appcastDescriptionField setEditable:editable];
    }
}

#pragma mark - Versions Customisation

- (void)windowWillEnterVersionBrowser:(NSNotification *)notification{
    [self makeUserInterfaceInteractive:NO forDocument:self];
}

- (void)windowDidExitVersionBrowser:(NSNotification *)notification{
    [self makeUserInterfaceInteractive:YES forDocument:self];
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
    [self startObservingUpdateInformation:newUpdate];
}

- (IBAction)deleteOldUpdate:(id)sender{
    SCAppcastItem *oldUpdate = [self.appcastFile.items objectAtIndex:self.appcastUpdatesArrayController.selectionIndex];
    [self.appcastUpdatesArrayController removeObjectAtArrangedObjectIndex:self.appcastUpdatesArrayController.selectionIndex];
    [self stopObservingUpdateInformation:oldUpdate];
}

#pragma mark - Undo Methods

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
    for(int i = 0; i < self.appcastFile.items.count; i++){
        [self stopObservingUpdateInformation:[self.appcastFile.items objectAtIndex:i]];
    }
}

@end
