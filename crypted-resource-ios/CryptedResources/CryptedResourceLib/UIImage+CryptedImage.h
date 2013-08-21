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

#import <UIKit/UIKit.h>

@interface UIImage (CryptedImage)

+ (UIImage*) imageWithCryptedData:(NSData*)encryptedData rawKey:(NSData*)rawKey;
+ (UIImage*) cryptedImageWithData:(NSData*)encryptedData rawKey:(NSData*)rawKey;
+ (UIImage*) cryptedImageNamed:(NSString *)name rawKey:(NSData*)rawKey;
+ (UIImage*) cryptedImageWithContentsOfFile:(NSString *)fullPath rawKey:(NSData*)rawKey;

+ (UIImage*) imageWithCryptedData:(NSData*)encryptedData hexKey:(NSString*)hexKey;
+ (UIImage*) cryptedImageWithData:(NSData*)encryptedData hexKey:(NSString*)hexKey;
+ (UIImage*) cryptedImageNamed:(NSString *)name hexKey:(NSString*)hexKey;
+ (UIImage*) cryptedImageWithContentsOfFile:(NSString *)fullPath hexKey:(NSString*)hexKey;

+ (UIImage*) imageWithCryptedData:(NSData*)encryptedData;
+ (UIImage*) cryptedImageWithData:(NSData*)encryptedData;
+ (UIImage*) cryptedImageNamed:(NSString *)name;
+ (UIImage*) cryptedImageWithContentsOfFile:(NSString *)fullPath;

@end
