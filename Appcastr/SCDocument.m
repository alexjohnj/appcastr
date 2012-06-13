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
@synthesize appcastFile, appcastDataController;
@synthesize appcastSettingsBox, appcastSettingsBoxIsHidden, appcastSettingsToggleDisclosureTriangle, appcastSettingsBoxWasHidden, appcastSettingsClickableLabel;

- (id)init
{
    self = [super init];
    if (self) {
        appcastFile = [[SCAppcastFile alloc] init];
//        [self startObservingAppcastModel:self.appcastData];
        appcastSettingsBoxIsHidden = YES;
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
        [self makeAppcastSettingsVisible:YES forWindow:aController.window]; // expands the appcast settings so that they are viewable in the versions browser 
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
//    [self stopObservingAppcastModel:self.appcastData];
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
//        [self startObservingAppcastModel:self.appcastData];
        return YES;
    }
}

# pragma mark - Appcast Settings Visibility Code

- (IBAction)toggleAppcastSettingsVisibility:(id)sender{
    if(sender == self.appcastSettingsClickableLabel){
        switch (self.appcastSettingsToggleDisclosureTriangle.state) {
            case NSOnState:
                self.appcastSettingsToggleDisclosureTriangle.state = NSOffState;
                break;
                
            case NSOffState:
                self.appcastSettingsToggleDisclosureTriangle.state = NSOnState;
                break;
        }
    }
    
    switch (self.appcastSettingsToggleDisclosureTriangle.state) {
        case NSOnState:
            [self makeAppcastSettingsVisible:YES forWindow:[sender window]];
            break;
        case NSOffState:
            [self makeAppcastSettingsVisible:NO forWindow:[sender window]];
            break;
    }
}

- (void)makeAppcastSettingsVisible:(BOOL)visible forWindow:(NSWindow *)window{
    NSWindow *currentWindow = window;
    NSRect currentWindowFrame = currentWindow.frame;
    NSRect appcastConfigBoxFrame = self.appcastSettingsBox.frame;
    
    if(visible == YES){
        [self.appcastSettingsToggleDisclosureTriangle setState:NSOnState];
        [self.appcastSettingsBox setHidden:NO];
        [currentWindow setFrame:NSMakeRect(currentWindowFrame.origin.x, currentWindowFrame.origin.y, currentWindowFrame.size.width, (currentWindowFrame.size.height + appcastConfigBoxFrame.size.height + 4)) display:YES animate:YES]; //we add 4 here to make sure we get 20px clearence between the NSBox and the window's frame. 
        self.appcastSettingsBoxIsHidden = NO;
    }
    else{
        [self.appcastSettingsToggleDisclosureTriangle setState:NSOffState];
        [currentWindow setFrame:NSMakeRect(currentWindowFrame.origin.x, currentWindowFrame.origin.y, currentWindowFrame.size.width, (currentWindowFrame.size.height - appcastConfigBoxFrame.size.height - 4)) display:YES animate:YES]; //likewise subtract 4 here to get the same 20px clearence.
        self.appcastSettingsBoxIsHidden = YES;
        [self.appcastSettingsBox setHidden:YES];
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
    
    [document.appcastSettingsToggleDisclosureTriangle setEnabled:editable]; // again, the argument name doesn't make a lot of sense. 
    [document.appcastSettingsClickableLabel setEnabled:editable];
}

#pragma mark - Versions Customisation

- (void)windowWillEnterVersionBrowser:(NSNotification *)notification{
    self.appcastSettingsBoxWasHidden = [self.appcastSettingsBox isHidden];
    [self makeUserInterfaceInteractive:NO forDocument:self];
    if(self.appcastSettingsBoxWasHidden == YES){
        [self makeAppcastSettingsVisible:YES forWindow:[notification object]]; // the object is the window which entered the versions browser
    }
}

- (void)windowDidExitVersionBrowser:(NSNotification *)notification{
    [self makeUserInterfaceInteractive:YES forDocument:self];
    if(self.appcastSettingsBoxWasHidden == YES){
        [self makeAppcastSettingsVisible:NO forWindow:[notification object]];
    }
}

#pragma mark - Window Restoration

- (void)window:(NSWindow *)window willEncodeRestorableState:(NSCoder *)state{
    NSNumber *appcastSettingsIsHidden = [NSNumber numberWithBool:self.appcastSettingsBox.isHidden];
    [state encodeObject:appcastSettingsIsHidden forKey:@"appcastSettingsIsHidden"];
}

- (void)window:(NSWindow *)window didDecodeRestorableState:(NSCoder *)state{
    self.appcastSettingsBoxIsHidden = [[state decodeObjectForKey:@"appcastSettingsIsHidden"] boolValue];
    if(self.appcastSettingsBoxIsHidden == NO){
        [self makeAppcastSettingsVisible:YES forWindow:window];
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
//    [self stopObservingAppcastModel:self.appcastData];
}

@end
