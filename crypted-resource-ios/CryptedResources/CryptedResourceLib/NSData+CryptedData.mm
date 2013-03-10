/**
 *  Copyright (c) 2013, Inmite s.r.o. (www.inmite.eu).
 *
 * All rights reserved. This source code can be used only for purposes specified
 * by the given license contract signed by the rightful deputy of Inmite s.r.o.
 * This source code can be used only by the owner of the license.
 *
 * Any disputes arising in respect of this agreement (license) shall be brought
 * before the Municipal Court of Prague.
 *
 */

#import "NSData+CryptedData.h"
#import "CryptedDataUtil.h"
#import "CryptedConstants.h"

@implementation NSData (CryptedData)

/**
 * Returns data obtained after decrypting crypted data using the client provided key.
 * @param encryptedData A chunk of crypted data to be decrypted.
 * @param hexKey A key used to decrypt the crypted data, hexadecimal string.
 * @return An instance of NSData obrained by decrypting the crypted data. The decrypted data
 * does not have to be valid when using the incorrect key.
 */
+ (NSData*) cryptedDataWithData:(NSData*)encryptedData hexKey:(NSString*)hexKey {
    size_t size;
    char *originalBytes = CryptedDataUtil::dataFromCryptedData((char*)[encryptedData bytes], [encryptedData length], (char*)[hexKey cStringUsingEncoding:NSASCIIStringEncoding], [hexKey length], &size);
    return [NSData dataWithBytesNoCopy:originalBytes length:size freeWhenDone:YES];
}

/**
 * Returns data obtained after decrypting crypted data stored in a specified file using
 * the client provided key.
 * @param fullPath A full path to the binary file with the crypted data.
 * @param hexKey A key used to decrypt the crypted data, hexadecimal string.
 * @return An instance of NSData obrained by decrypting the crypted data. The decrypted data
 * does not have to be valid when using the incorrect key.
 */
+ (NSData*) cryptedDataWithContentsOfFile:(NSString *)fullPath hexKey:(NSString*)hexKey {
    size_t size;
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        return nil;
    }
    char *originalBytes = CryptedDataUtil::dataFromCryptedFile([fullPath UTF8String], (char*)[hexKey cStringUsingEncoding:NSASCIIStringEncoding], [hexKey length], &size);
    return [NSData dataWithBytesNoCopy:originalBytes length:size freeWhenDone:YES];
}

/**
 * Returns data obtained after decrypting crypted data using the shared default key.
 * @param encryptedData A chunk of crypted data to be decrypted.
 * @return An instance of NSData obrained by decrypting the crypted data. The decrypted data
 * does not have to be valid when using the incorrect default key.
 */
+ (NSData*) cryptedDataWithData:(NSData*)encryptedData {
    return [NSData cryptedDataWithData:encryptedData hexKey:DEFAULT_KEY];
}

/**
 * Returns data obtained after decrypting crypted data stored in a specified file using
 * the shared default key.
 * @param fullPath A full path to the binary file with the crypted data.
 * @return An instance of NSData obrained by decrypting the crypted data. The decrypted data
 * does not have to be valid when using the incorrect default key.
 */
+ (NSData*) cryptedDataWithContentsOfFile:(NSString *)fullPath {
    return [NSData cryptedDataWithContentsOfFile:fullPath hexKey:DEFAULT_KEY];
}

@end
