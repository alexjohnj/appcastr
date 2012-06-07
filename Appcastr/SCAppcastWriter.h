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

- (NSXMLDocument *)prepareXMLDocumentFromAppCastData:(SCAppcastModel *)appCast;

@end
