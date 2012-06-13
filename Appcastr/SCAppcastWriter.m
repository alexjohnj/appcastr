//
//  SCAppcastWriter.m
//  Appcastr
//
//  Created by Alex Jackson on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SCAppcastWriter.h"

@implementation SCAppcastWriter

- (NSXMLDocument *)prepareXMLDocumentFromAppcastData:(SCAppcastModel *)appcast{
    
    NSXMLElement *rootElement = [self buildRootElement];
    NSXMLElement *channelElement = [self buildChannelElementFromAppcastData:appcast];
    NSXMLElement *channelItem = [self buildItemElementFromAppcastDatat:appcast];
    
    [channelElement addChild:channelItem];
    [rootElement addChild:channelElement];
    
    NSXMLDocument *appCastFile = [[NSXMLDocument alloc] initWithRootElement:rootElement];
    [appCastFile setVersion:@"1.0"];
    [appCastFile setCharacterEncoding:@"UTF-8"];
    [appCastFile setStandalone:YES];
    
    return appCastFile;
}

- (NSXMLElement *)buildRootElement{
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
    
    return rootElement;
    
}

- (NSXMLElement *)buildChannelElementFromAppcastData:(SCAppcastModel *)appcast{
    NSXMLElement *channelElement = [[NSXMLElement alloc] initWithName:@"channel"];
    
    if(appcast.appCastTitle){
        NSXMLElement *channelTitle = [[NSXMLElement alloc] initWithName:@"title" stringValue:appcast.appCastTitle];
        [channelElement addChild:channelTitle];
    }
    
    if(appcast.appCastLink){
        NSXMLElement *channelLink = [[NSXMLElement alloc] initWithName:@"link" stringValue:appcast.appCastLink];
        [channelElement addChild:channelLink];
    }
    
    if(appcast.appCastDescription){
        NSXMLElement *channelDescription = [[NSXMLElement alloc] initWithName:@"description" stringValue:appcast.appCastDescription];
        [channelElement addChild:channelDescription];
    }
    
    if(appcast.appCastLanguage){
        NSXMLElement *channelLanguage = [[NSXMLElement alloc] initWithName:@"language" stringValue:appcast.appCastLanguage];
        [channelElement addChild:channelLanguage];
    }
    
    return channelElement;
    
}

- (NSXMLElement *)buildItemElementFromAppcastDatat:(SCAppcastModel *)appcast{
    NSXMLElement *channelItem = [[NSXMLElement alloc] initWithName:@"item"];
    
    // Create the channelItem's children
    
    if(appcast.updateTitle){
        NSXMLElement *itemTitle = [[NSXMLElement alloc] initWithName:@"title" stringValue:appcast.updateTitle];
        [channelItem addChild:itemTitle];
    }
    
    
    if(appcast.updatePublicationDate){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
        NSXMLElement *itemPublicationDate = [[NSXMLElement alloc] initWithName:@"pubDate" stringValue:[dateFormatter stringFromDate:appcast.updatePublicationDate]];
        [channelItem addChild:itemPublicationDate];
    }
    
    if(appcast.updateReleaseNotesLink){
        NSXMLElement *itemReleaseNotesLink = [[NSXMLElement alloc] initWithName:@"sparkle:releaseNotesLink" stringValue:appcast.updateReleaseNotesLink];
        [channelItem addChild:itemReleaseNotesLink];
    }
    
    NSXMLElement *itemEnclosure = [[NSXMLElement alloc] initWithName:@"enclosure"];
    
    // Create the enclosure's attributes
    NSMutableArray *enclosureAttributesKeys = [[NSMutableArray alloc] init];
    NSMutableArray *enclosureAttributesValues = [[NSMutableArray alloc] init];
    
    if(appcast.updateDownloadLink){
        NSString *enclosureURLKey = [[NSString alloc] initWithString:@"url"];
        NSString *enclosureURL = [[NSString alloc] initWithString:appcast.updateDownloadLink];
        [enclosureAttributesKeys addObject:enclosureURLKey];
        [enclosureAttributesValues addObject:enclosureURL];
    }
    
    if(appcast.updateBuildNumber){
        NSString *enclosureBuildVersionKey = [[NSString alloc] initWithString:@"sparkle:version"];
        NSString *enclosureBuildVersion = [[NSString alloc] initWithString:appcast.updateBuildNumber];
        [enclosureAttributesKeys addObject:enclosureBuildVersionKey];
        [enclosureAttributesValues addObject:enclosureBuildVersion];
    }
    
    if(appcast.updateHumanReadableVersionNumber){
        NSString *enclosureHumanReadableVersionKey = [[NSString alloc] initWithString:@"sparkle:shortVersionString"];
        NSString *enclosureHumanReadableVersion = [[NSString alloc] initWithString:appcast.updateHumanReadableVersionNumber];
        [enclosureAttributesKeys addObject:enclosureHumanReadableVersionKey];
        [enclosureAttributesValues addObject:enclosureHumanReadableVersion];
    }
    
    if(appcast.updateLength){
        NSString *enclosureLengthKey = [[NSString alloc] initWithString:@"length"];
        NSString *enclosureLength = [[NSString alloc] initWithString:appcast.updateLength];
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
    
    if(appcast.updateSignature){
        NSString *enclosureDSASignatureKey = [[NSString alloc] initWithString:@"sparkle:dsaSignature"];
        NSString *enclosureDSASignature = [[NSString alloc] initWithString:appcast.updateSignature];
        [enclosureAttributesKeys addObject:enclosureDSASignatureKey];
        [enclosureAttributesValues addObject:enclosureDSASignature];
    }
    
    NSDictionary *enclosureAttributes = [NSDictionary dictionaryWithObjects:[enclosureAttributesValues copy]  forKeys:[enclosureAttributesKeys copy]];
    
    [itemEnclosure setAttributesWithDictionary:enclosureAttributes];
    
    [channelItem addChild:itemEnclosure];

    return channelItem;

}

@end
