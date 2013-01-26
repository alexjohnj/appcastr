//
//  SCAppcastItem.h
//  Appcastr
//
//  Created by Alex Jackson on 13/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCAppcastItem : NSObject

@property (strong) NSMutableString *updateReleaseNotesLink;
@property (strong) NSMutableString *updateTitle;
@property (strong) NSMutableString *updateMinimumSystemVersion;
@property (strong) NSMutableString *updateMaximumSystemVersion;
@property (assign) BOOL updateSpecifiesMinimumSystemVersion;
@property (assign) BOOL updateSpecifiesMaximumSystemVersion;
@property (strong) NSDate *updatePublicationDate;

// Declared in <enclosure> attributes

@property (strong) NSString *updateBuildNumber;
@property (strong) NSString *updateHumanReadableVersionNumber;
@property (strong) NSString *updateLength;
@property (strong) NSString *updateDownloadLink;
@property (strong) NSString *updateMimeType;
@property (strong) NSString *updateSignature;

@end
