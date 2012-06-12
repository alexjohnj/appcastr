//
//  SCDocument.h
//  Appcastr
//
//  Created by Alex Jackson on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SCAppcastModel.h"
#import "SCXMLParserDelegate.h"
#import "SCAppcastWriter.h"

@interface SCDocument : NSDocument <NSWindowDelegate>

@property (strong) SCAppcastModel *appcastData;
@property (weak) IBOutlet NSObjectController *appcastDataController;

@property (weak) IBOutlet NSTextField *updateTitleField;
@property (weak) IBOutlet NSTextField *updateBuildNumberField;
@property (weak) IBOutlet NSTextField *updateVersionNumberField;
@property (weak) IBOutlet NSTextField *updateDownloadLinkField;
@property (weak) IBOutlet NSTextField *updateReleaseNotesDownloadLinkField;
@property (weak) IBOutlet NSTextField *updateSignatureField;
@property (weak) IBOutlet NSTextField *updateSizeField;
@property (weak) IBOutlet NSDatePicker *updatePublicationDatePicker;
@property (weak) IBOutlet NSTextField *appcastNameField;
@property (weak) IBOutlet NSTextField *appcastLinkField;
@property (weak) IBOutlet NSTextField *appcastLanguageField;
@property (weak) IBOutlet NSTextField *appcastDescriptionField;

@property (weak) IBOutlet NSBox *appcastSettingsBox;
@property (weak) IBOutlet NSButton *appcastSettingsToggleDisclosureTriangle;
@property (assign) BOOL appcastSettingsBoxIsHidden;
@property (assign) BOOL appcastSettingsBoxWasHidden;

- (IBAction)toggleAppcastSettingsVisibility:(id)sender;
- (void)makeAppcastSettingsVisible:(BOOL)visible forWindow:(NSWindow *)window;
- (void)makeUserInterfaceEditable:(BOOL)editable forDocument:(SCDocument *)document;

- (void)startObservingAppcastModel:(SCAppcastModel *)model;
- (void)stopObservingAppcastModel:(SCAppcastModel *)model;

@end
