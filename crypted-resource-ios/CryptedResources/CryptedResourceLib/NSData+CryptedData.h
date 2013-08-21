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

#import <Foundation/Foundation.h>

@interface NSData (CryptedData)

+ (NSData*) cryptedDataWithData:(NSData*)originalData rawKey:(NSData*)rawKey;
+ (NSData*) cryptedDataWithData:(NSData*)originalData hexKey:(NSString*)hexKey;
+ (NSData*) cryptedDataWithData:(NSData*)originalData;
+ (NSData*) aes256cryptedDataWithData:(NSData*)originalData rawKey:(NSData*)rawKey;
+ (NSData*) aes256cryptedDataWithData:(NSData*)originalData hexKey:(NSString*)hexKey;
+ (NSData*) aes256cryptedDataWithData:(NSData*)originalData;

+ (NSData*) dataWithCryptedData:(NSData*)encryptedData rawKey:(NSData*)rawKey;
+ (NSData*) dataWithCryptedData:(NSData*)encryptedData hexKey:(NSString*)hexKey;
+ (NSData*) dataWithCryptedData:(NSData*)encryptedData;
+ (NSData*) dataWithAes256CryptedData:(NSData*)encryptedData rawKey:(NSData*)rawKey;
+ (NSData*) dataWithAes256CryptedData:(NSData*)encryptedData hexKey:(NSString*)hexKey;
+ (NSData*) dataWithAes256CryptedData:(NSData*)encryptedData;

+ (NSData*) dataWithContentsOfCryptedFile:(NSString *)fullPath rawKey:(NSData*)rawKey;
+ (NSData*) dataWithContentsOfCryptedFile:(NSString *)fullPath hexKey:(NSString*)hexKey;
+ (NSData*) dataWithContentsOfCryptedFile:(NSString *)fullPath;

+ (NSData*) dataWithContentsOfAes256CryptedFile:(NSString *)fullPath rawKey:(NSData*)rawKey;
+ (NSData*) dataWithContentsOfAes256CryptedFile:(NSString *)fullPath hexKey:(NSString*)hexKey;
+ (NSData*) dataWithContentsOfAes256CryptedFile:(NSString *)fullPath;


@end
