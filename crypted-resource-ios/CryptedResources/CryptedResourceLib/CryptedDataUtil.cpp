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

#include "CryptedDataUtil.h"
#include <cstdio>
#include <cstdlib>
#include <CommonCrypto/CommonCryptor.h>

#define hex(c) ((c >= '0' && c <= '9')?c - '0':((c >= 'a' && c <= 'f')?10 + c - 'a':((c >= 'A' && c <= 'F')?10 + c - 'A':-1)))

char *CryptedDataUtil::hex2bytes(char *hex, size_t len) {
    if (len % 2 != 0) {
        return NULL;
    }
    char *result = (char*)malloc(len / 2);
    for (int i = 0; i < len / 2; i++) {
        char upper = hex(hex[i * 2]);
        char lower = hex(hex[i * 2 + 1]);
        result[i] = upper * 16 + lower;
    }
    return result;
}

char* CryptedDataUtil::dataFromCryptedData(char* encryptedData, size_t dataLength, char *symKey, size_t symKeyLength, size_t * outputLength) {
    char *originalBytes = (char*) malloc(dataLength * sizeof(char));

    for (size_t i = 0; i < dataLength; i++) {
        originalBytes[i] = encryptedData[i] ^ symKey[i % symKeyLength];
    }
    
    // return the length of the resulting data
    *outputLength = dataLength;
    
    return originalBytes;
}

char* CryptedDataUtil::cryptedDataFromData(char* originalData, size_t dataLength, char *symKey, size_t symKeyLength, size_t * outputLength) {
    char *originalBytes = (char*) malloc(dataLength * sizeof(char));
    
    for (size_t i = 0; i < dataLength; i++) {
        originalBytes[i] = originalData[i] ^ symKey[i % symKeyLength];
    }
    
    // return the length of the resulting data
    *outputLength = dataLength;
    
    return originalBytes;
}

char* CryptedDataUtil::dataFromCryptedFile(const char* fileName, char *symKey, size_t symKeyLength, size_t * outputLength) {
    FILE* pFile;
    long lSize;
    char* encryptedData;
    size_t result;
    
    pFile = fopen(fileName, "rb" );
    if (pFile == NULL) {
        return NULL;
    }
    
    // obtain file size:
    fseek(pFile , 0 , SEEK_END);
    lSize = ftell(pFile);
    rewind(pFile);
    
    // allocate memory to contain the whole file:
    encryptedData = (char*) malloc(sizeof(char) * lSize);
    if (encryptedData == NULL) {
        return NULL;
    }
    
    // copy the file into the buffer:
    result = fread(encryptedData, 1, lSize, pFile);
    if (result != lSize) {
        return NULL;
    }
    
    fclose (pFile);
    
    char *originalBytes = dataFromCryptedData(encryptedData, lSize, symKey, symKeyLength, outputLength);
    
    free (encryptedData);
    
    return originalBytes;
    
}

char* CryptedDataUtil::aes256CryptedDataFromData(char *data, size_t data_length, char *key, size_t keyLength, size_t *outputLength) {
	char keyPtr[kCCKeySizeAES256 + 1];
	bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes
	
    // copy and nullpad the key
	for (int i = 0; i < keyLength && i < kCCKeySizeAES256+1; i++) {
        keyPtr[i] = key[i];
    }
	
	size_t bufferSize = data_length + kCCBlockSizeAES128;
	char *buffer = (char*)malloc(bufferSize);
	
	*outputLength = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL,
                                          data, data_length, /* input */
                                          buffer, bufferSize, /* output */
                                          outputLength);
	if (cryptStatus == kCCSuccess) {
		return buffer;
	}
    
	free(buffer); //free the buffer;
	return NULL;
}

char *CryptedDataUtil::aes256DataFromCryptedData(char *data, size_t data_length, char *key, size_t keyLength, size_t *outputLength) {
	char keyPtr[kCCKeySizeAES256 + 1];
	bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
	
	// copy and nullpad the key
	for (int i = 0; i < keyLength && i < kCCKeySizeAES256+1; i++) {
        keyPtr[i] = key[i];
    }
	
	size_t bufferSize = data_length + kCCBlockSizeAES128;
	char *buffer = (char*)malloc(bufferSize);
	
	*outputLength = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          data, data_length, /* input */
                                          buffer, bufferSize, /* output */
                                          outputLength);
	
	if (cryptStatus == kCCSuccess) {
		//the returned NSData takes ownership of the buffer and will free it on deallocation
		return buffer;
	}
	
	free(buffer); //free the buffer;
	return NULL;
}
