#ifndef _subtitle_123
#define _subtitle_123

/*
 * Interface File for subtitle handling (container input and output).
 *
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *
 */

typedef enum
{
    eSub_Gfx,
    eSub_Txt
} SubType_t;


typedef struct
{
    unsigned char* data;
    int            len;
} SubText_t;

typedef struct
{
    unsigned char* data;
    unsigned int   Width;
    unsigned int   Height;
    unsigned int   Stride;
    unsigned int   x;
    unsigned int   y;
    unsigned int   color;
} SubGfx_t;

typedef struct
{
    SubType_t      type;
    long long int  pts;
    float          duration;
    
    union
    {
        SubText_t text;
        SubGfx_t  gfx;
    } u;
} SubtitleOut_t;

typedef struct
{
    unsigned char* data;
    int            len;

    unsigned char* extradata;
    int            extralen;
    
    long long int  pts;
    float          duration;
} SubtitleData_t;

typedef struct
{
    unsigned char* destination;
    unsigned int   screen_width;
    unsigned int   screen_height;
    unsigned int   destStride;
    
    int            shareFramebuffer;
    int            framebufferFD;
} SubtitleOutputDef_t;

#endif