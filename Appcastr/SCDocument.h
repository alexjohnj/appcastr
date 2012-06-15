//
//  SCDocument.h
//  Appcastr
//
//  Created by Alex Jackson on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SCXMLParserDelegate.h"
#import "SCAppcastWriter.h"
#import "SCAppcastFile.h"

@interface SCDocument : NSDocument <NSWindowDelegate>

@property (strong) SCAppcastFile *appcastFile;
@property (weak) IBOutlet NSArrayController *appcastUpdatesArrayController;

@property (weak) IBOutlet NSTableView *sideBarTable;

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

- (IBAction)createNewUpdate:(id)sender;
- (IBAction)deleteOldUpdate:(id)sender;

- (void)startObservingUpdateInformation:(SCAppcastItem *)model;
- (void)stopObservingUpdateInformation:(SCAppcastItem *)model;

@end
