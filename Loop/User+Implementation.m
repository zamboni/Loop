//
//  User+Implementation.m
//  Loop
//
//  Created by Fletcher Fowler on 1/3/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import "User+Implementation.h"
#import "RHAddressBook.h"
#import "ABContact+Implementation.h"
#import "AFAmazonS3Client.h"

@implementation User (Implementation)

+ (RKEntityMapping *)entityMappingInManagedObjectStore:(RKManagedObjectStore *)managedObjectStore;
{
    RKEntityMapping *entityMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:managedObjectStore];
    entityMapping.identificationAttributes = @[@"rid"];
    [entityMapping addAttributeMappingsFromDictionary:@{ @"_id" : @"rid", @"email" : @"email" }];
    return entityMapping;
}

+ (void)setAccessTokenWithDictionary:(NSDictionary *)userDictionary
{
    [[ACSimpleKeychain defaultKeychain] storeUsername:[userDictionary objectForKey:@"_id"] password:[userDictionary objectForKey:@"access_token"] identifier:@"accessToken" forService:@"loop"];
}

+ (NSString *)getAccessToken
{
    ACSimpleKeychain *keychain = [ACSimpleKeychain defaultKeychain];
    NSDictionary *credentials = [keychain credentialsForIdentifier:@"accessToken" service:@"loop"];
    return [credentials valueForKey:ACKeychainPassword];
}

+ (NSString *)getCurrentUserId
{
    ACSimpleKeychain *keychain = [ACSimpleKeychain defaultKeychain];
    NSDictionary *credentials = [keychain credentialsForIdentifier:@"accessToken" service:@"loop"];
    return [credentials valueForKey:ACKeychainUsername];
}

+ (void)logout
{
    [[ACSimpleKeychain defaultKeychain] deleteCredentialsForIdentifier:@"accessToken" service:@"loop"];
}

- (ABContact *)createOrUpdateContact:(ABRecordRef)person{
    RHAddressBook *ab = [[RHAddressBook alloc] init];
    RHPerson *rhPerson = [ab personForABRecordID:ABRecordGetRecordID(person)];
//    [self uploadPhoto:rhPerson];
    
    ABContact *contact = [ABContact createPersonFromRHPerson:rhPerson inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    self.ab_contact = contact;
    
    NSNumber *contact_id = [NSNumber numberWithInt:ABRecordGetRecordID(person)];
    self.contactId = contact_id;
    
    return contact;
}

- (void)uploadPhoto:(RHPerson *)person
{
    UIImage *img = [person thumbnail];

    UIImage *resizedImage = img;
    NSData *jpegData = UIImageJPEGRepresentation(resizedImage, 0.5);
    NSString *key = [NSString stringWithFormat:@"/thumbs/%@.png", self.rid];
    NSString *tmpFile = [NSString pathWithComponents:@[NSTemporaryDirectory(), [NSString stringWithFormat:@"%@.png", self.rid]]];
    [jpegData writeToFile:tmpFile  atomically:NO];

    dispatch_async(dispatch_get_main_queue(), ^{
        
        // Upload to S3
        NSLog(@"Uploading to S3.....");
        AFAmazonS3Client *s3Client = [[AFAmazonS3Client alloc] initWithAccessKeyID:@"AKIAJZQTI3YJ5F2JPG6Q" secret:@"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"];
        
        NSString *destPath = [NSString stringWithFormat:@"http://loopapp.s3.amazonaws.com"];
        s3Client.bucket = @"loopapp";
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:key, @"key", nil];
        [s3Client postObjectWithFile:tmpFile destinationPath:destPath parameters:params progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
        } success:^(id responseObject) {
            NSLog(@"success");
        } failure:^(NSError *error) {
            NSLog(@"fail");
        }];
    });
}
@end
