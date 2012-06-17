//
//  SCAppcastSettingsPopoverViewController.m
//  Appcastr
//
//  Created by Alex Jackson on 17/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SCAppcastSettingsPopoverViewController.h"

@implementation SCAppcastSettingsPopoverViewController

@synthesize appcastTitleField, appcastLinkField, appcastDescriptionField, languagePopup, appcastFileController;

- (void)awakeFromNib{
    NSArray *systemLanguages = [NSLocale ISOLanguageCodes];
    [self.languagePopup removeAllItems];
    [self.languagePopup addItemsWithTitles:systemLanguages];
    [self.languagePopup selectItemWithTitle:[(SCAppcastFile *)self.representedObject appcastLanguage]];    
    
    if([[[NSDocumentController sharedDocumentController] currentDocument] isInViewingMode]){
        [self.appcastDescriptionField setEditable:NO];
        [self.appcastLinkField setEditable:NO];
        [self.appcastTitleField setEditable:NO];
        [self.languagePopup setEnabled:NO];
    }
}

@end
