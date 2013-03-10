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

#import "NSString+CryptedString.h"
#import "CryptedConstants.h"
#import "NSData+CryptedData.h"

@implementation NSString (CryptedString)

/**
 * Returns a string constructed from decrypted data using a specified NSString encoding.
 * This method uses client provided key to decrypt the data.
 * @param encryptedData A crypted data with the contents of the original string.
 * @param encoding An NSString encoding to be used when converting raw bytes to string instance.
 * @param hexKey A key used to decrypt the crypted data, a hexadecimal string.
 * @return An instance of NSString with decrypted data from the original bytes in NSData instance, or null
 * if the decryption was not successful.
 */
+ (NSString*) cryptedStringWithData:(NSData*)encryptedData encoding:(NSStringEncoding)encoding hexKey:(NSString *)hexKey {
    NSData *data = [NSData cryptedDataWithData:encryptedData hexKey:hexKey];
    return [[NSString alloc] initWithData:data encoding:encoding];
}

/**
 * Returns an original string read from the crypted file using a specified NSString encoding.
 * This method uses client provided key to decrypt the data.
 * @param fullPath A full path to the crypted text file with the contents of the string.
 * @param encoding An NSString encoding to be used when converting raw bytes to string instance.
 * @param hexKey A key used to decrypt the crypted file, a hexadecimal string.
 * @return An instance of NSString with decrypted data from the file, or null
 * if the decryption was not successful or file does not exist.
 */
+ (NSString*) cryptedStringWithContentsOfFile:(NSString *)fullPath encoding:(NSStringEncoding)encoding hexKey:(NSString *)hexKey {
    NSData *data = [NSData cryptedDataWithContentsOfFile:fullPath hexKey:hexKey];
    return [[NSString alloc] initWithData:data encoding:encoding];
}

/**
 * Returns a string constructed from decrypted data using a specified NSString encoding.
 * This method uses shared default key to decrypt the data.
 * @param encryptedData A crypted data with the contents of the original string.
 * @param encoding An NSString encoding to be used when converting raw bytes to string instance.
 * @return An instance of NSString with decrypted data from the original bytes in NSData instance, or null
 * if the decryption was not successful.
 */
+ (NSString*) cryptedStringWithData:(NSData*)encryptedData encoding:(NSStringEncoding)encoding {
    return [NSString cryptedStringWithData:encryptedData encoding:encoding hexKey:DEFAULT_KEY];
}

/**
 * Returns an original string read from the crypted file using a specified NSString encoding.
 * This method uses shared default key to decrypt the data.
 * @param fullPath A full path to the crypted text file with the contents of the string.
 * @param encoding An NSString encoding to be used when converting raw bytes to string instance.
 * @return An instance of NSString with decrypted data from the file, or null
 * if the decryption was not successful or file does not exist.
 */
+ (NSString*) cryptedStringWithContentsOfFile:(NSString *)fullPath encoding:(NSStringEncoding)encoding {
    return [NSString cryptedStringWithContentsOfFile:fullPath encoding:encoding hexKey:DEFAULT_KEY];
}

@end
