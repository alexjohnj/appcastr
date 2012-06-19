//
//  AdvancedUpdateInformationSheetController.m
//  Appcastr
//
//  Created by Alex Jackson on 19/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SCAdvancedUpdateInformationSheetController.h"

@implementation SCAdvancedUpdateInformationSheetController
@synthesize currentlySelectedUpdate= _currentlySelectedUpdate, currentUpdateController = _currentUpdateController;
@synthesize minimumUpdateField, minimumUpdateCheckbox, maximumUpdateField, maximumUpdateCheckbox;

- (id)initWithWindowNibName:(NSString *)windowNibName appcastUpdate:(SCAppcastItem *)update{
    self = [super initWithWindowNibName:windowNibName];
    if(self){
        if(!update)
            return nil;
        
        _currentlySelectedUpdate = update;
    }
    
    return self;
}

- (void)windowDidLoad
{
    if([[[NSDocumentController sharedDocumentController] currentDocument] isInViewingMode]){
        [self.minimumUpdateCheckbox setEnabled:NO];
        [self.maximumUpdateCheckbox setEnabled:NO];
        [self.minimumUpdateField setEditable:NO];
        [self.maximumUpdateField setEditable:NO];
    }
    
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)toggleMinMaxVersions:(id)sender{
    if([sender isEqualTo:self.maximumUpdateCheckbox]){
        [self.window makeFirstResponder:self.maximumUpdateField];
    }
    else if([sender isEqualTo:self.minimumUpdateCheckbox]){
        [self.window makeFirstResponder:self.minimumUpdateField];
    }
}

- (IBAction)closeSheet:(id)sender{
    [self.currentUpdateController commitEditing];
    [NSApp endSheet:self.window];
}

@end
