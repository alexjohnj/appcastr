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
#import "SCAppcastConfigurationWindowController.h"
#import "SCAppcastWriter.h"

@interface SCDocument : NSDocument

@property (strong) SCAppcastModel *appcastData;
@property (strong) SCAppcastConfigurationWindowController *appcastConfigurationSheet;

- (IBAction)showAppcastConfigurationSheet:(id)sender;
- (void)sheetDidEnd:(NSWindow *)sheet resultCode:(NSInteger)resultCode contextInfo:(void *)contextInfo;

@end
