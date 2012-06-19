//
//  AdvancedUpdateInformationSheetController.h
//  Appcastr
//
//  Created by Alex Jackson on 19/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SCAppcastItem.h"

@interface SCAdvancedUpdateInformationSheetController : NSWindowController

@property (strong) SCAppcastItem *currentlySelectedUpdate;
@property (strong) IBOutlet NSObjectController *currentUpdateController;

@property (weak) IBOutlet NSTextField *minimumUpdateField;
@property (weak) IBOutlet NSTextField *maximumUpdateField;
@property (weak) IBOutlet NSButton *minimumUpdateCheckbox;
@property (weak) IBOutlet NSButton *maximumUpdateCheckbox;

- (id)initWithWindowNibName:(NSString *)windowNibName appcastUpdate:(SCAppcastItem *)update;

- (IBAction)closeSheet:(id)sender;
- (IBAction)toggleMinMaxVersions:(id)sender;

@end
