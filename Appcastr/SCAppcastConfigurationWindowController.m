//
//  SCAppcastConfigurationWindowController.m
//  Appcastr
//
//  Created by Alex Jackson on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SCAppcastConfigurationWindowController.h"

@implementation SCAppcastConfigurationWindowController

@synthesize appcastData;
@synthesize appcastNameField;

- (id)initWithWindowNibName:(NSString *)nibName appcastData:(SCAppcastModel *)appcast
{
    self = [super initWithWindowNibName:nibName];
    if (self) {
        if(!appcast)
            return nil;
        
        appcastData = appcast;
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [self.window makeFirstResponder:self.appcastNameField];
}

- (IBAction)closeSheet:(id)sender{
    [NSApp endSheet:self.window];
}

@end
