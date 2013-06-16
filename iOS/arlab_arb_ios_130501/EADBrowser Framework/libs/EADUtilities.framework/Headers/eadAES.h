//
//  AES.h
//  demosAES2
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//
//  Version 1.5
//
#pragma once

#ifndef eadAES_H
#define eadAES_H

class eadAES
{
    public:        

        eadAES(void);

        __attribute__((__visibility__("default"))) eadAES(bool _debug);
    
        __attribute__((__visibility__("default"))) char* ApiChk(char*_ak, char*_k, char*_d);

        char* base64(const unsigned char *input, int length);
    
        char *pt(unsigned char *md);
    
    private:
    
        bool _debug;
};

#endif