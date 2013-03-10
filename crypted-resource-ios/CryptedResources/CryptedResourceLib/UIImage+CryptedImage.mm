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

#import "UIImage+CryptedImage.h"
#import "CryptedDataUtil.h"
#import "CryptedConstants.h"

@implementation UIImage (CryptedImage)

/**
 * Returns a UIImage from the crypted image file specified by the full path. This method uses client provided key
 * to decrypt the data.
 * @param fullPath A full path to the crypted image file.
 * @param hexKey A key used to decrypt the crypted file, a hexadecimal string.
 * @return An instance of UIImage in case the file exists and was successfully decrypted, null otherwise.
 */
+ (UIImage*) cryptedImageWithContentsOfFile:(NSString *)fullPath hexKey:(NSString *)hexKey {
    UIImage *image = nil;
    size_t size;
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        return nil;
    }
    char *originalBytes = CryptedDataUtil::dataFromCryptedFile([fullPath UTF8String], (char*)[hexKey cStringUsingEncoding:NSASCIIStringEncoding], [hexKey length], &size);
    NSData *data = [NSData dataWithBytesNoCopy:originalBytes length:size freeWhenDone:YES];
    image = [UIImage imageWithData:data];
    return image;
}

/**
 * Returns a UIImage from the crypted image in the application bundle. This method uses client provided key
 * to decrypt the data.
 * @param name A crypted image name in the bundle, including the file extension.
 * @param hexKey A key used to decrypt the crypted resource, a hexadecimal string.
 * @return An instance of UIImage in case the resource exists in the bundle and was successfully decrypted, null otherwise.
 */
+ (UIImage*) cryptedImageNamed:(NSString *)name hexKey:(NSString *)hexKey {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@""];
    if (path == nil) {
        return nil;
    }
    return [UIImage cryptedImageWithContentsOfFile:path];
}

/**
 * Returns a UIImage from the crypted chunk of data. This method uses client provided key
 * to decrypt the data.
 * @param encryptedData A chunk of crypted data that includes a crypted image.
 * @param hexKey A key used to decrypt the crypted data, a hexadecimal string.
 * @return An instance of UIImage in case the data contain umage after being decrypted, null otherwise.
 */
+ (UIImage*) cryptedImageWithData:(NSData*)encryptedData hexKey:(NSString *)hexKey {
    UIImage *image = nil;
    size_t size;
    char *originalBytes = CryptedDataUtil::dataFromCryptedData((char*)[encryptedData bytes], [encryptedData length], (char*)[hexKey cStringUsingEncoding:NSASCIIStringEncoding], [hexKey length], &size);
    NSData *data = [NSData dataWithBytesNoCopy:originalBytes length:size freeWhenDone:YES];
    image = [UIImage imageWithData:data];
    return image;
}

/**
 * Returns a UIImage from the crypted chunk of data. This method uses default shared key
 * to decrypt the data.
 * @param encryptedData A chunk of crypted data that includes a crypted image.
 * @return An instance of UIImage in case the data contain umage after being decrypted, null otherwise.
 */
+ (UIImage*) cryptedImageWithData:(NSData*)encryptedData {
    return [UIImage cryptedImageWithData:encryptedData hexKey:DEFAULT_KEY];
}

/**
 * Returns a UIImage from the crypted image in the application bundle. This method uses default shared key
 * to decrypt the data.
 * @param name A crypted image name in the bundle, including the file extension.
 * @return An instance of UIImage in case the resource exists in the bundle and was successfully decrypted, null otherwise.
 */
+ (UIImage*) cryptedImageNamed:(NSString *)name {
    return [UIImage cryptedImageNamed:name hexKey:DEFAULT_KEY];
}

/**
 * Returns a UIImage from the crypted image file specified by the full path. This method uses default shared key
 * to decrypt the data.
 * @param fullPath A full path to the crypted image file.
 * @return An instance of UIImage in case the file exists and was successfully decrypted, null otherwise.
 */
+ (UIImage*) cryptedImageWithContentsOfFile:(NSString *)fullPath {
    return [UIImage cryptedImageWithContentsOfFile:fullPath hexKey:DEFAULT_KEY];
}


@end
