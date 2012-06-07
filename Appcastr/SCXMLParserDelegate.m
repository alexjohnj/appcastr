//
//  SCXMLParserDelegate.m
//  Appcastr
//
//  Created by Alex Jackson on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SCXMLParserDelegate.h"

@implementation SCXMLParserDelegate

@synthesize appcastData, isItemElement, currentElement, currentAttributes;

-(id)init{
    self = [super init];
    if(self){
        appcastData = [[SCAppcastModel alloc] init];
        isItemElement = NO;
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
    
    if(self.currentElement)
        self.currentElement = nil;
    if(self.currentAttributes)
        self.currentAttributes = nil;
    
    self.currentElement = [[NSString alloc] initWithString:elementName];
    self.currentAttributes = [[NSDictionary alloc] initWithDictionary:attributeDict];
    
    if([elementName isEqualToString:@"item"]){
        self.isItemElement = YES;
    }
    
    if([elementName isEqualToString:@"enclosure"]){
        if([attributeDict objectForKey:@"url"])
            self.appcastData.updateDownloadLink = [[NSString alloc] initWithString:[attributeDict objectForKey:@"url"]];
        if([attributeDict objectForKey:@"sparkle:version"])
            self.appcastData.updateBuildNumber = [[NSString alloc] initWithString:[attributeDict objectForKey:@"sparkle:version"]];
        if([attributeDict objectForKey:@"length"])
            self.appcastData.updateLength = [[NSString alloc] initWithString:[attributeDict objectForKey:@"length"]];
        if([attributeDict objectForKey:@"type"])
            self.appcastData.updateMimeType = [[NSString alloc] initWithString:[attributeDict objectForKey:@"type"]];
        if([attributeDict objectForKey:@"sparkle:dsaSignature"])
            self.appcastData.updateSignature = [[NSString alloc] initWithString:[attributeDict objectForKey:@"sparkle:dsaSignature"]];
        if([attributeDict objectForKey:@"sparkle:shortVersionString"])
            self.appcastData.updateHumanReadableVersionNumber = [[NSString alloc] initWithString:[attributeDict objectForKey:@"sparkle:shortVersionString"]];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    self.currentElement = nil;
    self.currentAttributes = nil;
    
    if([elementName isEqualToString:@"item"])
        self.isItemElement = NO;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{    
    if([self.currentElement isEqualToString:@"title"] && !self.isItemElement)
        self.appcastData.appCastTitle = [[NSString alloc] initWithString:string];
    
    if([self.currentElement isEqualToString:@"link"])
        self.appcastData.appCastLink = [[NSString alloc] initWithString:string];
    
    if([self.currentElement isEqualToString:@"description"] && !self.isItemElement)
        self.appcastData.appCastDescription = [[NSString alloc] initWithString:string];
    
    if([self.currentElement isEqualToString:@"language"])
        self.appcastData.appCastLanguage = [[NSString alloc] initWithString:string];
    
    if([self.currentElement isEqualToString:@"sparkle:releaseNotesLink"])
        self.appcastData.updateReleaseNotesLink = [[NSString alloc] initWithString:string];  
    
    if([self.currentElement isEqualToString:@"title"] && self.isItemElement)
        self.appcastData.updateTitle = [[NSString alloc] initWithString:string];
    
    if([self.currentElement isEqualToString:@"pubDate"])
        self.appcastData.updatePublicationDate = [NSDate dateWithNaturalLanguageString:string];
}

@end
