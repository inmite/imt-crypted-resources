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

#pragma mark - XOR encryption support

/**
 * Returns data obtained after decrypting crypted data using the client provided raw key.
 * @param encryptedData A chunk of crypted data to be decrypted.
 * @param rawKey A key used to decrypt the crypted data, raw bytes.
 * @return An instance of NSData obrained by decrypting the crypted data. The decrypted data
 * does not have to be valid when using the incorrect key.
 */
+ (NSData*) dataWithCryptedData:(NSData*)encryptedData rawKey:(NSData*)rawKey {
    size_t size;
    char *originalBytes = CryptedDataUtil::dataFromCryptedData((char*)[encryptedData bytes], [encryptedData length], (char*)[rawKey bytes], [rawKey length], &size);
    return [NSData dataWithBytesNoCopy:originalBytes length:size freeWhenDone:YES];
}

/**
 * Returns data obtained after decrypting crypted data stored in a specified file using
 * the client provided raw key.
 * @param fullPath A full path to the binary file with the crypted data.
 * @param rawKey A key used to decrypt the crypted data, raw bytes.
 * @return An instance of NSData obrained by decrypting the crypted data. The decrypted data
 * does not have to be valid when using the incorrect key.
 */
+ (NSData*) dataWithContentsOfCryptedFile:(NSString *)fullPath rawKey:(NSData*)rawKey {
    size_t size;
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        return nil;
    }
    char *originalBytes = CryptedDataUtil::dataFromCryptedFile([fullPath UTF8String], (char*)[rawKey bytes], [rawKey length], &size);
    return [NSData dataWithBytesNoCopy:originalBytes length:size freeWhenDone:YES];
}

/**
 * Returns data obtained after decrypting crypted data using the client provided key.
 * @param encryptedData A chunk of crypted data to be decrypted.
 * @param hexKey A key used to decrypt the crypted data, hexadecimal string.
 * @return An instance of NSData obrained by decrypting the crypted data. The decrypted data
 * does not have to be valid when using the incorrect key.
 */
+ (NSData*) dataWithCryptedData:(NSData*)encryptedData hexKey:(NSString*)hexKey {
    size_t size;
    char *rawKey = CryptedDataUtil::hex2bytes((char*)[hexKey cStringUsingEncoding:NSASCIIStringEncoding], [hexKey length]);
    char *originalBytes = CryptedDataUtil::dataFromCryptedData((char*)[encryptedData bytes], [encryptedData length], (char*)rawKey, [hexKey length] / 2, &size);
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
+ (NSData*) dataWithContentsOfCryptedFile:(NSString *)fullPath hexKey:(NSString*)hexKey {
    size_t size;
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        return nil;
    }
    char *rawKey = CryptedDataUtil::hex2bytes((char*)[hexKey cStringUsingEncoding:NSASCIIStringEncoding], [hexKey length]);
    char *originalBytes = CryptedDataUtil::dataFromCryptedFile([fullPath UTF8String], (char*)rawKey, [hexKey length] / 2, &size);
    return [NSData dataWithBytesNoCopy:originalBytes length:size freeWhenDone:YES];
}

/**
 * Returns data obtained after decrypting crypted data using the shared default key.
 * @param encryptedData A chunk of crypted data to be decrypted.
 * @return An instance of NSData obrained by decrypting the crypted data. The decrypted data
 * does not have to be valid when using the incorrect default key.
 */
+ (NSData*) dataWithCryptedData:(NSData*)encryptedData {
    return [NSData cryptedDataWithData:encryptedData hexKey:DEFAULT_KEY];
}

/**
 * Returns data obtained after decrypting crypted data stored in a specified file using
 * the shared default key.
 * @param fullPath A full path to the binary file with the crypted data.
 * @return An instance of NSData obrained by decrypting the crypted data. The decrypted data
 * does not have to be valid when using the incorrect default key.
 */
+ (NSData*) dataWithContentsOfCryptedFile:(NSString *)fullPath {
    return [NSData dataWithContentsOfCryptedFile:fullPath hexKey:DEFAULT_KEY];
}

/**
 * Return an encrypted data by crypting the original data with a default key.
 * @param originalData A original data to be encrypted.
 * @return Encrypted original data using the default key.
 */
+ (NSData *)cryptedDataWithData:(NSData *)originalData {
    return [NSData cryptedDataWithData:originalData hexKey:DEFAULT_KEY];
}

/**
 * Return an encrypted data by crypting the original data with a provided hexadecimal key.
 * @param originalData A original data to be encrypted.
 * @param hexKey A hexadecimal string to be used as a key for encryption.
 * @return Encrypted original data using the provided hexadecimal key.
 */
+ (NSData *)cryptedDataWithData:(NSData *)originalData hexKey:(NSString *)hexKey {
    size_t size;
    char *rawKey = CryptedDataUtil::hex2bytes((char*)[hexKey cStringUsingEncoding:NSASCIIStringEncoding], [hexKey length]);
    char *cryptedBytes = CryptedDataUtil::cryptedDataFromData((char*)[originalData bytes], originalData.length, rawKey, [hexKey length] / 2, &size);
    return [NSData dataWithBytesNoCopy:cryptedBytes length:size freeWhenDone:YES];
}

/**
 * Return an encrypted data by crypting the original data with a provided raw key.
 * @param originalData A original data to be encrypted.
 * @param hexKey A raw data to be used as a key for encryption.
 * @return Encrypted original data using the provided raw key.
 */
+ (NSData *)cryptedDataWithData:(NSData *)originalData rawKey:(NSData *)rawKey {
    size_t size;
    char *cryptedBytes = CryptedDataUtil::cryptedDataFromData((char*)[originalData bytes], originalData.length, (char*)[rawKey bytes], rawKey.length, &size);
    return [NSData dataWithBytesNoCopy:cryptedBytes length:size freeWhenDone:YES];
}

#pragma mark - AES256 encryption support

/**
 * Return an original data by AES256 decrypting the encrypted data with a privided raw key.
 * @param encryptedData The encrypted data to be decrypted using AES256 algorithm with given raw binary key to obtain the original data.
 * @param rawKey A raw key to be used for AES256 encryption.
 * @return Original data.
 */
+ (NSData *)dataWithAes256CryptedData:(NSData *)encryptedData rawKey:(NSData *)rawKey {
    size_t size;
    char *cryptedBytes = CryptedDataUtil::aes256DataFromCryptedData((char*)[encryptedData bytes], encryptedData.length, (char*)[rawKey bytes], rawKey.length, &size);
    return [NSData dataWithBytesNoCopy:cryptedBytes length:size freeWhenDone:YES];
}

/**
 * Return an original data by AES256 decrypting the encrypted data with a privided hex key.
 * @param encryptedData The encrypted data to be decrypted using AES256 algorithm with given hex key to obtain the original data.
 * @param rawKey A hex key to be used for AES256 encryption.
 * @return Original data.
 */
+ (NSData *)dataWithAes256CryptedData:(NSData *)encryptedData hexKey:(NSString *)hexKey {
    size_t size;
    char *rawKey = CryptedDataUtil::hex2bytes((char*)[hexKey cStringUsingEncoding:NSASCIIStringEncoding], [hexKey length]);
    char *cryptedBytes = CryptedDataUtil::aes256DataFromCryptedData((char*)[encryptedData bytes], encryptedData.length, rawKey, [hexKey length] / 2, &size);
    return [NSData dataWithBytesNoCopy:cryptedBytes length:size freeWhenDone:YES];
}

/**
 * Return an original data by AES256 decrypting the encrypted data with the default key.
 * @param encryptedData The encrypted data to be decrypted using AES256 algorithm with the default key to obtain the original data.
 * @return Original data.
 */
+ (NSData *)dataWithAes256CryptedData:(NSData *)encryptedData {
    size_t size;
    char *rawKey = CryptedDataUtil::hex2bytes((char*)[DEFAULT_KEY cStringUsingEncoding:NSASCIIStringEncoding], [DEFAULT_KEY length]);
    char *cryptedBytes = CryptedDataUtil::aes256DataFromCryptedData((char*)[encryptedData bytes], encryptedData.length, rawKey, [DEFAULT_KEY length] / 2, &size);
    return [NSData dataWithBytesNoCopy:cryptedBytes length:size freeWhenDone:YES];
}

/**
 * Return an encrypted data by AES256 crypting the original data with a privided raw key.
 * @param originalData The original data to be encrypted using AES256 algorithm with given raw binary key.
 * @param rawKey A raw key to be used for AES256 encryption.
 * @return AES256 encrypted data using a given raw key.
 */
+ (NSData *)aes256cryptedDataWithData:(NSData *)originalData rawKey:(NSData *)rawKey {
    size_t size;
    char *cryptedBytes = CryptedDataUtil::aes256CryptedDataFromData((char*)[originalData bytes], originalData.length, (char*)[rawKey bytes], rawKey.length, &size);
    return [NSData dataWithBytesNoCopy:cryptedBytes length:size freeWhenDone:YES];    
}

/**
 * Return an encrypted data by AES256 crypting the original data with a privided hex key.
 * @param originalData The original data to be encrypted using AES256 algorithm with given hex key.
 * @param hexKey A hex key to be used for AES256 encryption.
 * @return AES256 encrypted data using a given hex key.
 */
+ (NSData *)aes256cryptedDataWithData:(NSData *)originalData hexKey:(NSString *)hexKey {
    size_t size;
    char *rawKey = CryptedDataUtil::hex2bytes((char*)[hexKey cStringUsingEncoding:NSASCIIStringEncoding], [hexKey length]);
    char *cryptedBytes = CryptedDataUtil::aes256CryptedDataFromData((char*)[originalData bytes], originalData.length, rawKey, [hexKey length] / 2, &size);
    return [NSData dataWithBytesNoCopy:cryptedBytes length:size freeWhenDone:YES];
}

/**
 * Return an encrypted data by AES256 crypting the original data with the default key.
 * @param originalData The original data to be encrypted using AES256 algorithm with the default key.
 * @return AES256 encrypted data using the default key.
 */
+ (NSData *)aes256cryptedDataWithData:(NSData *)originalData {
    size_t size;
    char *rawKey = CryptedDataUtil::hex2bytes((char*)[DEFAULT_KEY cStringUsingEncoding:NSASCIIStringEncoding], [DEFAULT_KEY length]);
    char *cryptedBytes = CryptedDataUtil::aes256CryptedDataFromData((char*)[originalData bytes], originalData.length, rawKey, [DEFAULT_KEY length] / 2, &size);
    return [NSData dataWithBytesNoCopy:cryptedBytes length:size freeWhenDone:YES];
}

/**
 * Returns data obtained after decrypting crypted data stored in a specified file using
 * AES256 algorithm with the client provided raw key.
 * @param fullPath A full path to the binary file with the AES256 crypted data.
 * @param rawKey A key used to decrypt the crypted data, raw bytes.
 * @return An instance of NSData obrained by decrypting the crypted data using AES256. The decrypted data
 * does not have to be valid when using the incorrect key.
 */
+ (NSData*) dataWithContentsOfAes256CryptedFile:(NSString *)fullPath rawKey:(NSData*)rawKey {
    size_t size;
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        return nil;
    }
    char *originalBytes = CryptedDataUtil::aes256DataFromCryptedFile([fullPath UTF8String], (char*)[rawKey bytes], [rawKey length], &size);
    return [NSData dataWithBytesNoCopy:originalBytes length:size freeWhenDone:YES];
}

/**
 * Returns data obtained after decrypting crypted data stored in a specified file using
 * AES256 algorithm with the client provided hex key.
 * @param fullPath A full path to the binary file with the AES256 crypted data.
 * @param hex A key used to decrypt the crypted data, raw bytes.
 * @return An instance of NSData obrained by decrypting the crypted data using AES256. The decrypted data
 * does not have to be valid when using the incorrect key.
 */
+ (NSData*) dataWithContentsOfAes256CryptedFile:(NSString *)fullPath hexKey:(NSString*)hexKey {
    size_t size;
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        return nil;
    }
    char *rawKey = CryptedDataUtil::hex2bytes((char*)[hexKey cStringUsingEncoding:NSASCIIStringEncoding], [hexKey length]);
    char *originalBytes = CryptedDataUtil::aes256DataFromCryptedFile([fullPath UTF8String], (char*)rawKey, [hexKey length] / 2, &size);
    return [NSData dataWithBytesNoCopy:originalBytes length:size freeWhenDone:YES];
}

/**
 * Returns data obtained after decrypting crypted data stored in a specified file using
 * AES256 algorithm with the default key.
 * @param fullPath A full path to the binary file with the AES256 crypted data.
 * @return An instance of NSData obrained by decrypting the crypted data using AES256. The decrypted data
 * does not have to be valid when using the incorrect key.
 */
+ (NSData*) dataWithContentsOfAes256CryptedFile:(NSString *)fullPath {
    return [NSData dataWithContentsOfAes256CryptedFile:fullPath hexKey:DEFAULT_KEY];
}

@end
