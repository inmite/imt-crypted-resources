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

@interface NSString (CryptedString)

+ (NSString*) stringWithCryptedData:(NSData*)encryptedData encoding:(NSStringEncoding)encoding rawKey:(NSData*)rawKey;
+ (NSString*) stringWithContentsOfCryptedFile:(NSString *)fullPath encoding:(NSStringEncoding)encoding rawKey:(NSData*)rawKey;

+ (NSString*) stringWithCryptedData:(NSData*)encryptedData encoding:(NSStringEncoding)encoding hexKey:(NSString*)hexKey;
+ (NSString*) stringWithContentsOfCryptedFile:(NSString *)fullPath encoding:(NSStringEncoding)encoding hexKey:(NSString*)hexKey;

+ (NSString*) stringWithCryptedData:(NSData*)encryptedData encoding:(NSStringEncoding)encoding;
+ (NSString*) stringWithContentsOfCryptedFile:(NSString *)fullPath encoding:(NSStringEncoding)encoding;

@end
