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

@interface SCDocument : NSDocument

@property (strong) SCAppcastModel *appcastData;

@end
