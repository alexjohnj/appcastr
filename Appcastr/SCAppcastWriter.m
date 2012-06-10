//
//  SCAppcastWriter.m
//  Appcastr
//
//  Created by Alex Jackson on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SCAppcastWriter.h"

@implementation SCAppcastWriter

- (NSXMLDocument *)prepareXMLDocumentFromAppCastData:(SCAppcastModel *)appCast{
    
    // Create the root element
    
    NSXMLElement *rootElement = [[NSXMLElement alloc] initWithName:@"rss"];
    
    // create the root element's attributes
    
    NSString *rssVersionKey = [[NSString alloc] initWithString:@"version"];
    NSString *rssVersion = [[NSString alloc] initWithString:@"2.0"];
    
    NSString *xmlnsSparkleKey = [[NSString alloc] initWithString:@"xmlns:sparkle"];
    NSString *xmlnsSparkle = [[NSString alloc] initWithString:@"http://www.andymatuschak.org/xml-namespaces/sparkle"];
    
    NSString *xmlnsDCKey = [[NSString alloc] initWithString:@"xmlns:dc"];
    NSString *xmlnsDC = [[NSString alloc] initWithString:@"http://purl.org/dc/elements/1.1/"];
    
    NSArray *attributeKeys = [NSArray arrayWithObjects:rssVersionKey, xmlnsSparkleKey, xmlnsDCKey, nil];
    NSArray *attributeValues = [NSArray arrayWithObjects:rssVersion, xmlnsSparkle, xmlnsDC, nil];
    NSDictionary *rootElementAttributes = [[NSDictionary alloc] initWithObjects:attributeValues forKeys:attributeKeys];
    
    // Add the attributes to the root element
    
    [rootElement setAttributesWithDictionary:rootElementAttributes];
    
    // That's the root element
    // Create the channel element
    
    NSXMLElement *channelElement = [[NSXMLElement alloc] initWithName:@"channel"];
    
    // Create the channel's children
    
    if(appCast.appCastTitle){
        NSXMLElement *channelTitle = [[NSXMLElement alloc] initWithName:@"title" stringValue:appCast.appCastTitle];
        [channelElement addChild:channelTitle];
    }
    
    if(appCast.appCastLink){
        NSXMLElement *channelLink = [[NSXMLElement alloc] initWithName:@"link" stringValue:appCast.appCastLink];
        [channelElement addChild:channelLink];
    }
    
    if(appCast.appCastDescription){
        NSXMLElement *channelDescription = [[NSXMLElement alloc] initWithName:@"description" stringValue:appCast.appCastDescription];
        [channelElement addChild:channelDescription];
    }
    
    if(appCast.appCastLanguage){
        NSXMLElement *channelLanguage = [[NSXMLElement alloc] initWithName:@"language" stringValue:appCast.appCastLanguage];
        [channelElement addChild:channelLanguage];
    }
    
    NSXMLElement *channelItem = [[NSXMLElement alloc] initWithName:@"item"];
    
    // Create the channelItem's children
    
    if(appCast.updateTitle){
        NSXMLElement *itemTitle = [[NSXMLElement alloc] initWithName:@"title" stringValue:appCast.updateTitle];
        [channelItem addChild:itemTitle];
    }
    
    
    if(appCast.updatePublicationDate){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setDateFormat:@"EEE, dd MMM yyyy hh:mm:ss Z"];
        NSXMLElement *itemPublicationDate = [[NSXMLElement alloc] initWithName:@"pubDate" stringValue:[dateFormatter stringFromDate:appCast.updatePublicationDate]];
        [channelItem addChild:itemPublicationDate];
    }
    
    if(appCast.updateReleaseNotesLink){
        NSXMLElement *itemReleaseNotesLink = [[NSXMLElement alloc] initWithName:@"sparkle:releaseNotesLink" stringValue:appCast.updateReleaseNotesLink];
        [channelItem addChild:itemReleaseNotesLink];
    }
    
    NSXMLElement *itemEnclosure = [[NSXMLElement alloc] initWithName:@"enclosure"];
    
    // Create the enclosure's attributes
    NSMutableArray *enclosureAttributesKeys = [[NSMutableArray alloc] init];
    NSMutableArray *enclosureAttributesValues = [[NSMutableArray alloc] init];
    
    if(appCast.updateDownloadLink){
        NSString *enclosureURLKey = [[NSString alloc] initWithString:@"url"];
        NSString *enclosureURL = [[NSString alloc] initWithString:appCast.updateDownloadLink];
        [enclosureAttributesKeys addObject:enclosureURLKey];
        [enclosureAttributesValues addObject:enclosureURL];
    }
    
    if(appCast.updateBuildNumber){
        NSString *enclosureBuildVersionKey = [[NSString alloc] initWithString:@"sparkle:version"];
        NSString *enclosureBuildVersion = [[NSString alloc] initWithString:appCast.updateBuildNumber];
        [enclosureAttributesKeys addObject:enclosureBuildVersionKey];
        [enclosureAttributesValues addObject:enclosureBuildVersion];
    }
    
    if(appCast.updateHumanReadableVersionNumber){
        NSString *enclosureHumanReadableVersionKey = [[NSString alloc] initWithString:@"sparkle:shortVersionString"];
        NSString *enclosureHumanReadableVersion = [[NSString alloc] initWithString:appCast.updateHumanReadableVersionNumber];
        [enclosureAttributesKeys addObject:enclosureHumanReadableVersionKey];
        [enclosureAttributesValues addObject:enclosureHumanReadableVersion];
    }
    
    if(appCast.updateLength){
        NSString *enclosureLengthKey = [[NSString alloc] initWithString:@"length"];
        NSString *enclosureLength = [[NSString alloc] initWithString:appCast.updateLength];
        [enclosureAttributesKeys addObject:enclosureLengthKey];
        [enclosureAttributesValues addObject:enclosureLength];
    }
    
    // Support for custom mimetypes will be implemented in a future version of Appcastr, currently we just default to "application/octet-stream"
    
//    if(appCast.updateMimeType){
//        NSString *enclosureTypeKey = [[NSString alloc] initWithString:@"type"];
//        NSString *enclosureType = [[NSString alloc] initWithString:appCast.updateMimeType];
//        [enclosureAttributesKeys addObject:enclosureTypeKey];
//        [enclosureAttributesValues addObject:enclosureType];
//    }
    
    NSString *enclosureTypeKey = [[NSString alloc] initWithString:@"type"];
    NSString *enclosureType = [[NSString alloc] initWithString:@"application/octet-stream"];
    [enclosureAttributesKeys addObject:enclosureTypeKey];
    [enclosureAttributesValues addObject:enclosureType];
    
    if(appCast.updateSignature){
        NSString *enclosureDSASignatureKey = [[NSString alloc] initWithString:@"sparkle:dsaSignature"];
        NSString *enclosureDSASignature = [[NSString alloc] initWithString:appCast.updateSignature];
        [enclosureAttributesKeys addObject:enclosureDSASignatureKey];
        [enclosureAttributesValues addObject:enclosureDSASignature];
    }
    
    NSDictionary *enclosureAttributes = [NSDictionary dictionaryWithObjects:[enclosureAttributesValues copy]  forKeys:[enclosureAttributesKeys copy]];
    
    [itemEnclosure setAttributesWithDictionary:enclosureAttributes];
    
    [channelItem addChild:itemEnclosure];
    [channelElement addChild:channelItem];
    [rootElement addChild:channelElement];
    
    NSXMLDocument *appCastFile = [[NSXMLDocument alloc] initWithRootElement:rootElement];
    [appCastFile setVersion:@"1.0"];
    [appCastFile setCharacterEncoding:@"UTF-8"];
    [appCastFile setStandalone:YES];
    
    return appCastFile;
}

@end
