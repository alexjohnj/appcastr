//
//  SCAppcastSettingsPopoverViewController.m
//  Appcastr
//
//  Created by Alex Jackson on 17/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SCAppcastSettingsPopoverViewController.h"

@implementation SCAppcastSettingsPopoverViewController

@synthesize appcastTitleField, appcastLanguageField, appcastLinkField, appcastDescriptionField;

- (void)awakeFromNib{
    if([[[NSDocumentController sharedDocumentController] currentDocument] isInViewingMode]){
        [self.appcastDescriptionField setEditable:NO];
        [self.appcastLanguageField setEditable:NO];
        [self.appcastLinkField setEditable:NO];
        [self.appcastTitleField setEditable:NO];
    }
}

@end
