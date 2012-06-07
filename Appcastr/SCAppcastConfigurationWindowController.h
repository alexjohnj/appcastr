//
//  SCAppcastConfigurationWindowController.h
//  Appcastr
//
//  Created by Alex Jackson on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SCAppcastModel.h"

@interface SCAppcastConfigurationWindowController : NSWindowController

@property (strong) SCAppcastModel *appcastData;

- (IBAction)closeSheet:(id)sender;

- (id)initWithWindowNibName:(NSString *)nibName appcastData:(SCAppcastModel *)appcast;

@end
