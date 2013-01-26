//
//  SCAppcastModel.m
//  Appcastr
//
//  Created by Alex Jackson on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SCAppcastModel.h"

@implementation SCAppcastModel

- (id)init{
    self = [super init];
    
    if(self){
        _updateBuildNumber = [[NSString alloc] init];
        _updateTitle = [[NSString alloc] init];
        _updateSignature = [[NSString alloc] init];
        _updateDownloadLink = [[NSString alloc] init];
        _updateReleaseNotesLink = [[NSString alloc] init];
        _updateLength = [[NSString alloc] init];
        _updateMimeType = [[NSString alloc] init];
        _updatePublicationDate = [[NSDate alloc] init];
        _updateHumanReadableVersionNumber = [[NSString alloc] init];
        
        _appCastLink = [[NSString alloc] init];
        _appCastTitle = [[NSString alloc] init];
        _appCastLanguage = [[NSString alloc] init];
        _appCastDescription = [[NSString alloc] init];
    }
    
    return self;
}

@end
