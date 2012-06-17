//
//  SCAppcastSettingsPopoverViewController.h
//  Appcastr
//
//  Created by Alex Jackson on 17/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SCAppcastSettingsPopoverViewController : NSViewController

@property (weak) IBOutlet NSTextField *appcastTitleField;
@property (weak) IBOutlet NSTextField *appcastLanguageField;
@property (weak) IBOutlet NSTextField *appcastLinkField;
@property (weak) IBOutlet NSTextField *appcastDescriptionField;


@end
