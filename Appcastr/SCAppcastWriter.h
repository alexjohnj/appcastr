//
//  SCAppcastWriter.h
//  Appcastr
//
//  Created by Alex Jackson on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCAppcastModel.h"
#import "SCAppcastItem.h"
#import "SCAppcastFile.h"

@interface SCAppcastWriter : NSObject

- (NSXMLDocument *)prepareXMLDocumentFromAppcastData:(SCAppcastFile *)appcastFile;

- (NSXMLElement *)buildRootElement;
- (NSXMLElement *)buildChannelElementFromAppcastData:(SCAppcastFile *)appcastFile;
- (NSXMLElement *)buildItemElementFromAppcastData:(SCAppcastItem *)appcastItem;

@end
