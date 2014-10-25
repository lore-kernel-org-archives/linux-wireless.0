Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:64788 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaJYUHE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 16:07:04 -0400
Received: by mail-wg0-f43.google.com with SMTP id n12so3167146wgh.14
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 13:07:03 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 40/48] staging: vt6655: dead code remove country.h
Date: Sat, 25 Oct 2014 09:40:18 +0100
Message-Id: <1414226426-5811-41-git-send-email-tvboxspy@gmail.com> (sfid-20141025_220710_710177_2D263B3C)
In-Reply-To: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
References: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/channel.c |   1 -
 drivers/staging/vt6655/country.h | 161 ---------------------------------------
 2 files changed, 162 deletions(-)
 delete mode 100644 drivers/staging/vt6655/country.h

diff --git a/drivers/staging/vt6655/channel.c b/drivers/staging/vt6655/channel.c
index d505fa3..49c2d9a 100644
--- a/drivers/staging/vt6655/channel.c
+++ b/drivers/staging/vt6655/channel.c
@@ -21,7 +21,6 @@
  */
 
 #include "baseband.h"
-#include "country.h"
 #include "channel.h"
 #include "device.h"
 #include "rf.h"
diff --git a/drivers/staging/vt6655/country.h b/drivers/staging/vt6655/country.h
deleted file mode 100644
index 2365fb1..0000000
--- a/drivers/staging/vt6655/country.h
+++ /dev/null
@@ -1,161 +0,0 @@
-/*
- * Copyright (c) 1996, 2003 VIA Networking Technologies, Inc.
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
- *
- *
- * File: country.h
- *
- * Purpose: Country Code information
- *
- * Author: Lucas Lin
- *
- * Date: Dec 23, 2004
- *
- */
-
-#ifndef __COUNTRY_H__
-#define __COUNTRY_H__
-
-#include "ttype.h"
-
-/************************************************************************
- * The definition here should be complied with the INF country order
- * Please check with VNWL.inf/VNWL64.inf/VNWL*.inf
- ************************************************************************/
-typedef enum _COUNTRY_CODE {
-	CCODE_FCC = 0,
-	CCODE_TELEC,
-	CCODE_ETSI,
-	CCODE_RESV3,
-	CCODE_RESV4,
-	CCODE_RESV5,
-	CCODE_RESV6,
-	CCODE_RESV7,
-	CCODE_RESV8,
-	CCODE_RESV9,
-	CCODE_RESVa,
-	CCODE_RESVb,
-	CCODE_RESVc,
-	CCODE_RESVd,
-	CCODE_RESVe,
-	CCODE_ALLBAND,
-	CCODE_ALBANIA,
-	CCODE_ALGERIA,
-	CCODE_ARGENTINA,
-	CCODE_ARMENIA,
-	CCODE_AUSTRALIA,
-	CCODE_AUSTRIA,
-	CCODE_AZERBAIJAN,
-	CCODE_BAHRAIN,
-	CCODE_BELARUS,
-	CCODE_BELGIUM,
-	CCODE_BELIZE,
-	CCODE_BOLIVIA,
-	CCODE_BRAZIL,
-	CCODE_BRUNEI_DARUSSALAM,
-	CCODE_BULGARIA,
-	CCODE_CANADA,
-	CCODE_CHILE,
-	CCODE_CHINA,
-	CCODE_COLOMBIA,
-	CCODE_COSTA_RICA,
-	CCODE_CROATIA,
-	CCODE_CYPRUS,
-	CCODE_CZECH,
-	CCODE_DENMARK,
-	CCODE_DOMINICAN_REPUBLIC,
-	CCODE_ECUADOR,
-	CCODE_EGYPT,
-	CCODE_EL_SALVADOR,
-	CCODE_ESTONIA,
-	CCODE_FINLAND,
-	CCODE_FRANCE,
-	CCODE_GERMANY,
-	CCODE_GREECE,
-	CCODE_GEORGIA,
-	CCODE_GUATEMALA,
-	CCODE_HONDURAS,
-	CCODE_HONG_KONG,
-	CCODE_HUNGARY,
-	CCODE_ICELAND,
-	CCODE_INDIA,
-	CCODE_INDONESIA,
-	CCODE_IRAN,
-	CCODE_IRELAND,
-	CCODE_ITALY,
-	CCODE_ISRAEL,
-	CCODE_JAPAN,
-	CCODE_JORDAN,
-	CCODE_KAZAKHSTAN,
-	CCODE_KUWAIT,
-	CCODE_LATVIA,
-	CCODE_LEBANON,
-	CCODE_LEICHTENSTEIN,
-	CCODE_LITHUANIA,
-	CCODE_LUXEMBURG,
-	CCODE_MACAU,
-	CCODE_MACEDONIA,
-	CCODE_MALTA,
-	CCODE_MALAYSIA,
-	CCODE_MEXICO,
-	CCODE_MONACO,
-	CCODE_MOROCCO,
-	CCODE_NETHERLANDS,
-	CCODE_NEW_ZEALAND,
-	CCODE_NORTH_KOREA,
-	CCODE_NORWAY,
-	CCODE_OMAN,
-	CCODE_PAKISTAN,
-	CCODE_PANAMA,
-	CCODE_PERU,
-	CCODE_PHILIPPINES,
-	CCODE_POLAND,
-	CCODE_PORTUGAL,
-	CCODE_PUERTO_RICO,
-	CCODE_QATAR,
-	CCODE_ROMANIA,
-	CCODE_RUSSIA,
-	CCODE_SAUDI_ARABIA,
-	CCODE_SINGAPORE,
-	CCODE_SLOVAKIA,
-	CCODE_SLOVENIA,
-	CCODE_SOUTH_AFRICA,
-	CCODE_SOUTH_KOREA,
-	CCODE_SPAIN,
-	CCODE_SWEDEN,
-	CCODE_SWITZERLAND,
-	CCODE_SYRIA,
-	CCODE_TAIWAN,
-	CCODE_THAILAND,
-	CCODE_TRINIDAD_TOBAGO,
-	CCODE_TUNISIA,
-	CCODE_TURKEY,
-	CCODE_UK,
-	CCODE_UKRAINE,
-	CCODE_UNITED_ARAB_EMIRATES,
-	CCODE_UNITED_STATES,
-	CCODE_URUGUAY,
-	CCODE_UZBEKISTAN,
-	CCODE_VENEZUELA,
-	CCODE_VIETNAM,
-	CCODE_YEMEN,
-	CCODE_ZIMBABWE,
-	CCODE_JAPAN_W52_W53,
-	CCODE_MAX
-} COUNTRY_CODE;
-
-#endif  /* __COUNTRY_H__ */
-- 
1.9.1

