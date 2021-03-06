//
//  BoxAppToAppMetadata.m
//  BoxSDK
//
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BoxAppToAppFileMetadata.h"
#import "BoxAppToAppAnnotationKeys.h"
#import "BoxAppToAppAnnotationBuilder.h"

void nilSafePut(NSMutableDictionary *dict, NSString *key, id value)
{
    // note that setValue:forKey: is nil-safe, unlike "dict[key] = value"
    [dict setValue:value forKey:key];
}

@interface BoxAppToAppFileMetadata()

@property (nonatomic, readwrite, strong) NSDictionary *allMetadata;

@end

@implementation BoxAppToAppFileMetadata

- (id)initWithInfo:(NSDictionary *)info
{
    if (self = [self init])
    {
        _allMetadata = [NSDictionary dictionaryWithDictionary:info];
    }

    return self;
}

+ (BoxAppToAppFileMetadata *)appToAppFileMetadataWithInfo:(NSDictionary *)info
{
    return [[BoxAppToAppFileMetadata alloc] initWithInfo:info];
}

+ (BoxAppToAppFileMetadata *)appToAppFileMetadataWithMetadata:(BoxAppToAppFileMetadata *)originalMetadata changingFileNameTo:(NSString *)newFileName
{
    // by default, remove the fileID when you rename it, as it will upload as an entirely new file due to the changed name
    return [self appToAppFileMetadataWithMetadata:originalMetadata changingFileNameTo:newFileName fileID:nil];
}

+ (BoxAppToAppFileMetadata *)appToAppFileMetadataWithMetadata:(BoxAppToAppFileMetadata *)originalMetadata changingFileNameTo:(NSString *)newFileName fileID:(NSString *)fileID
{
    BoxAppToAppFileMetadata *result = originalMetadata;
    if ([newFileName isEqualToString:originalMetadata.fileName] == NO || fileID != nil)
    {
        NSMutableDictionary *updatedDictionary = [NSMutableDictionary dictionaryWithDictionary:originalMetadata.allMetadata];

        nilSafePut(updatedDictionary, BOX_APP_TO_APP_METADATA_FILE_NAME_KEY, newFileName);
        nilSafePut(updatedDictionary, BOX_APP_TO_APP_METADATA_FILE_EXTENSION_KEY,
                     [newFileName pathExtension]);
        nilSafePut(updatedDictionary, BOX_APP_TO_APP_METADATA_FILE_ID_KEY, fileID);

        result = [BoxAppToAppFileMetadata appToAppFileMetadataWithInfo:updatedDictionary];
    }

    return result;
}

+ (BoxAppToAppFileMetadata *)appToAppFileMetadataWithFileName:(NSString *)fileName
                                                fileExtension:(NSString *)fileExtension
                                                   folderName:(NSString *)folderName
                                                     mimeType:(NSString *)mimeType
                                                       fileID:(NSString *)fileID
                                                     folderID:(NSString *)folderID
                                                     username:(NSString *)username
                                                       userID:(NSString *)userID
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];

    nilSafePut(info, BOX_APP_TO_APP_METADATA_FILE_NAME_KEY,      fileName);
    nilSafePut(info, BOX_APP_TO_APP_METADATA_FILE_EXTENSION_KEY, fileExtension);
    nilSafePut(info, BOX_APP_TO_APP_METADATA_FOLDER_NAME_KEY,    folderName);
    nilSafePut(info, BOX_APP_TO_APP_METADATA_FILE_MIME_TYPE_KEY, mimeType);
    nilSafePut(info, BOX_APP_TO_APP_METADATA_FILE_ID_KEY,        fileID);
    nilSafePut(info, BOX_APP_TO_APP_METADATA_FOLDER_ID_KEY,      folderID);
    nilSafePut(info, BOX_APP_TO_APP_METADATA_USERNAME_KEY,       username);
    nilSafePut(info, BOX_APP_TO_APP_METADATA_USER_ID_KEY,        userID);

    return [self appToAppFileMetadataWithInfo:info];
}

+ (BoxAppToAppFileMetadata *)appToAppFileMetadataWithFileName:(NSString *)fileName
                                                fileExtension:(NSString *)fileExtension
                                                   folderPath:(NSString *)folderPath
                                                     mimeType:(NSString *)mimeType
                                                       fileID:(NSString *)fileID
                                               folderPathByID:(NSString *)folderPathByID
                                                     username:(NSString *)username
                                                       userID:(NSString *)userID
{
    NSString *folderName = [folderPath lastPathComponent];
    NSString *folderID = [folderPathByID lastPathComponent];

    BoxAppToAppFileMetadata *initialMetadata = [self appToAppFileMetadataWithFileName:fileName
                                                                        fileExtension:fileExtension
                                                                           folderName:folderName
                                                                             mimeType:mimeType
                                                                               fileID:fileID
                                                                             folderID:folderID
                                                                             username:username
                                                                               userID:userID];
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:initialMetadata.allMetadata];
    nilSafePut(info, BOX_APP_TO_APP_METADATA_FOLDER_PATH_KEY,       folderPath);
    nilSafePut(info, BOX_APP_TO_APP_METADATA_FOLDER_PATH_BY_ID_KEY, folderPathByID);

    return [self appToAppFileMetadataWithInfo:info];
}

- (NSString *)fileName
{
    return [BoxAppToAppAnnotationBuilder stringFromAnnotationString:
            self.allMetadata[BOX_APP_TO_APP_METADATA_FILE_NAME_KEY]];
}

- (NSString *)folderPathStringByName
{
    return [BoxAppToAppAnnotationBuilder stringFromAnnotationString:
            self.allMetadata[BOX_APP_TO_APP_METADATA_FOLDER_PATH_KEY]];
}

- (NSString *)folderName
{
    return [BoxAppToAppAnnotationBuilder stringFromAnnotationString:
            self.allMetadata[BOX_APP_TO_APP_METADATA_FOLDER_NAME_KEY]];
}

- (NSString *)fileExtension
{
    return [BoxAppToAppAnnotationBuilder stringFromAnnotationString:
            self.allMetadata[BOX_APP_TO_APP_METADATA_FILE_EXTENSION_KEY]];
}

- (NSString *)fileMimeType
{
    return [BoxAppToAppAnnotationBuilder stringFromAnnotationString:
            self.allMetadata[BOX_APP_TO_APP_METADATA_FILE_MIME_TYPE_KEY]];
}

- (NSString *)fileID
{
    return [BoxAppToAppAnnotationBuilder stringFromAnnotationString:
            self.allMetadata[BOX_APP_TO_APP_METADATA_FILE_ID_KEY]];
}

- (NSString *)folderID
{
    return [BoxAppToAppAnnotationBuilder stringFromAnnotationString:
            self.allMetadata[BOX_APP_TO_APP_METADATA_FOLDER_ID_KEY]];
}

- (NSString *)folderPathStringByID
{
    return [BoxAppToAppAnnotationBuilder stringFromAnnotationString:
            self.allMetadata[BOX_APP_TO_APP_METADATA_FOLDER_PATH_BY_ID_KEY]];
}

- (NSString *)username
{
    return [BoxAppToAppAnnotationBuilder stringFromAnnotationString:
            self.allMetadata[BOX_APP_TO_APP_METADATA_USERNAME_KEY]];
}

- (NSString *)userID
{
    return [BoxAppToAppAnnotationBuilder stringFromAnnotationString:
            self.allMetadata[BOX_APP_TO_APP_METADATA_USER_ID_KEY]];
}

- (NSString *)description
{
    return [self.allMetadata description];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_allMetadata forKey:@"allMetadata"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithInfo:[aDecoder decodeObjectForKey:@"allMetadata"]];
}

@end
