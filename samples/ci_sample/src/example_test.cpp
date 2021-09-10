/*****************************************************************************
 * Project:  LibCMaker_HarfBuzz
 * Purpose:  A CMake build script for HarfBuzz library
 * Author:   NikitaFeodonit, nfeodonit@yandex.com
 *****************************************************************************
 *   Copyright (c) 2017-2019 NikitaFeodonit
 *
 *    This file is part of the LibCMaker_HarfBuzz project.
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published
 *    by the Free Software Foundation, either version 3 of the License,
 *    or (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *    See the GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program. If not, see <http://www.gnu.org/licenses/>.
 ****************************************************************************/

// The code is based on the code from
// <expat>/examples/elements.c

#include <expat.h>
#include <stdio.h>

#ifdef XML_LARGE_SIZE
#if defined(XML_USE_MSC_EXTENSIONS) && _MSC_VER < 1400
#define XML_FMT_INT_MOD "I64"
#else
#define XML_FMT_INT_MOD "ll"
#endif
#else
#define XML_FMT_INT_MOD "l"
#endif

#ifdef XML_UNICODE_WCHAR_T
#include <wchar.h>
#define XML_FMT_STR "ls"
#else
#define XML_FMT_STR "s"
#endif

#include "gtest/gtest.h"

static void XMLCALL startElement(void *userData, const XML_Char *name,
                                 const XML_Char **atts) {
  int i;
  int *depthPtr = (int *)userData;
  (void)atts;

  for (i = 0; i < *depthPtr; i++)
    putchar('\t');
  printf("%" XML_FMT_STR "\n", name);
  *depthPtr += 1;
}

static void XMLCALL endElement(void *userData, const XML_Char *name) {
  int *depthPtr = (int *)userData;
  (void)name;

  *depthPtr -= 1;
}

TEST(Examle, test) {
  XML_Parser parser = XML_ParserCreate(NULL);
  int depth = 0;

  XML_SetUserData(parser, &depth);
  XML_SetElementHandler(parser, startElement, endElement);
  XML_ParserFree(parser);
  EXPECT_TRUE(true);
}
