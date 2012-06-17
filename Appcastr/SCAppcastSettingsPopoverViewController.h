//
//  SCAppcastSettingsPopoverViewController.h
//  Appcastr
//
//  Created by Alex Jackson on 17/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SCAppcastFile.h"

@interface SCAppcastSettingsPopoverViewController : NSViewController

@property (strong) IBOutlet NSObjectController *appcastFileController;

@property (weak) IBOutlet NSTextField *appcastTitleField;
@property (weak) IBOutlet NSTextField *appcastLinkField;
@property (weak) IBOutlet NSTextField *appcastDescriptionField;
@property (weak) IBOutlet NSPopUpButton *languagePopup;

@end
