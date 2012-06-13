//
//  SCAppcastItem.h
//  Appcastr
//
//  Created by Alex Jackson on 13/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCAppcastItem : NSObject

@property (strong) NSString *updateBuildNumber;
@property (strong) NSString *updateHumanReadableVersionNumber;
@property (strong) NSString *updateSignature;
@property (strong) NSString *updateDownloadLink;
@property (strong) NSString *updateReleaseNotesLink;
@property (strong) NSString *updateTitle;
@property (strong) NSString *updateLength;
@property (strong) NSString *updateMimeType;
@property (strong) NSDate *updatePublicationDate;

@end
