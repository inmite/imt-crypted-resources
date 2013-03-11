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

#ifndef __CryptedDataUtil__
#define __CryptedDataUtil__

#include <iostream>

using namespace std;

class CryptedDataUtil {
public:
    static char* hex2bytes(char *hex, size_t len);
    static char* dataFromCryptedData(char* encryptedData, size_t dataLength, char *symKey, size_t symKeyLength, size_t * outputLength);
    static char* cryptedDataFromData(char* originalData, size_t dataLength, char *symKey, size_t symKeyLength, size_t * outputLength);
    static char* dataFromCryptedFile(const char* fileName, char *symKey, size_t symKeyLength, size_t * outputLength);
    static char* aes256CryptedDataFromData(char *data, size_t data_length, char *key, size_t keyLength, size_t *outputLength);
    static char* aes256DataFromCryptedData(char *data, size_t data_length, char *key, size_t keyLength, size_t *outputLength);
    
};

#endif /* defined(__CryptedDataUtil__) */
