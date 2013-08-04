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

+ (NSData*) cryptedDataWithData:(NSData*)encryptedData rawKey:(NSData*)rawKey;
+ (NSData*) cryptedDataWithData:(NSData*)encryptedData hexKey:(NSString*)hexKey;
+ (NSData*) cryptedDataWithData:(NSData*)encryptedData;

+ (NSData*) dataWithCryptedData:(NSData*)encryptedData rawKey:(NSData*)rawKey;
+ (NSData*) dataWithCryptedData:(NSData*)encryptedData hexKey:(NSString*)hexKey;
+ (NSData*) dataWithCryptedData:(NSData*)encryptedData;

+ (NSData*) cryptedDataWithContentsOfFile:(NSString *)fullPath rawKey:(NSData*)rawKey;
+ (NSData*) cryptedDataWithContentsOfFile:(NSString *)fullPath hexKey:(NSString*)hexKey;
+ (NSData*) cryptedDataWithContentsOfFile:(NSString *)fullPath;

@end
