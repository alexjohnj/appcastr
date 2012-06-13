//
//  SCAppcastWriter.h
//  Appcastr
//
//  Created by Alex Jackson on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCAppcastModel.h"

@interface SCAppcastWriter : NSObject

- (NSXMLDocument *)prepareXMLDocumentFromAppcastData:(SCAppcastModel *)appcast;

- (NSXMLElement *)buildRootElement;
- (NSXMLElement *)buildChannelElementFromAppcastData:(SCAppcastModel *)appcast;
- (NSXMLElement *)buildItemElementFromAppcastDatat:(SCAppcastModel *)appcast;

@end
