//
//  SCDocument.m
//  Appcastr
//
//  Created by Alex Jackson on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SCDocument.h"

@implementation SCDocument
@synthesize appcastData, appcastConfigurationSheet;

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
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
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

//- (BOOL)writeToURL:(NSURL *)url ofType:(NSString *)type{
//    SCAppcastWriter *appcastCreator = [[SCAppcastWriter alloc] init];
//    NSXMLDocument *appcastFile = [appcastCreator prepareXMLDocumentFromAppCastData:self.appcastData];
//    
//    NSData *appcastFileDataRepresentation = [appcastFile XMLData];
//    if([appcastFileDataRepresentation writeToURL:url atomically:YES]){
//        return YES;
//    }
//    
//    else{
//        return NO;
//    }
//}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
    SCAppcastWriter *appcastCreator = [[SCAppcastWriter alloc] init];
    NSXMLDocument *appcastFile = [appcastCreator prepareXMLDocumentFromAppCastData:self.appcastData];
    
    NSData *appcastFileDataRepresentation = [appcastFile XMLDataWithOptions:NSXMLNodePrettyPrint];
    
    return appcastFileDataRepresentation;
}

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
    NSXMLDocument *appcastFile = [[NSXMLDocument alloc] initWithContentsOfURL:url options:NSXMLDocumentTidyXML error:nil];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[appcastFile XMLData]];
    SCXMLParserDelegate *xmlParserDelegate = [[SCXMLParserDelegate alloc] init];
    
    [xmlParser setDelegate:xmlParserDelegate];
    
    BOOL parseSuccesful = [xmlParser parse];
    
    if(!parseSuccesful){
        *outError = [xmlParser parserError];
        return NO;
    }
    
    else{
        appcastData = xmlParserDelegate.appcastData;
        return YES;
    }

}

- (IBAction)showAppcastConfigurationSheet:(id)sender{
    if(self.appcastConfigurationSheet)
        self.appcastConfigurationSheet = nil;
    
    appcastConfigurationSheet = [[SCAppcastConfigurationWindowController alloc] initWithWindowNibName:@"SCAppcastConfigurationSheet" appcastData:self.appcastData];
    
    [NSApp beginSheet:self.appcastConfigurationSheet.window
       modalForWindow:self.windowForSheet
        modalDelegate:self
       didEndSelector:@selector(sheetDidEnd:resultCode:contextInfo:)
          contextInfo:NULL];
}

- (void)sheetDidEnd:(NSWindow *)sheet resultCode:(NSInteger)resultCode contextInfo:(void *)contextInfo {
    if(sheet == self.appcastConfigurationSheet.window){
        NSLog(@"Called");
        self.appcastData = self.appcastConfigurationSheet.appcastData;
        [sheet orderOut:self];
    }
}

@end
