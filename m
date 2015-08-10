Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33868 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbbHJCdh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2015 22:33:37 -0400
Received: by pawu10 with SMTP id u10so129137962paw.1
        for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2015 19:33:37 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 03/11] staging: wilc1000: remove WILC_strlen function
Date: Mon, 10 Aug 2015 11:33:14 +0900
Message-Id: <1439174002-7365-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20150810_043351_572226_02D85554)
In-Reply-To: <1439174002-7365-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439174002-7365-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove WILC_strlen function that is changed to strlen.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_strutils.c |  9 ---------
 drivers/staging/wilc1000/wilc_strutils.h | 10 ----------
 2 files changed, 19 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_strutils.c b/drivers/staging/wilc1000/wilc_strutils.c
index a32b9c1..205a06a 100644
--- a/drivers/staging/wilc1000/wilc_strutils.c
+++ b/drivers/staging/wilc1000/wilc_strutils.c
@@ -50,12 +50,3 @@ s32 WILC_strncmp(const char *pcStr1, const char *pcStr2,
 	return s32Result;
 }
 
-/*!
- *  @author	syounan
- *  @date	18 Aug 2010
- *  @version	1.0
- */
-u32 WILC_strlen(const char *pcStr)
-{
-	return (u32)strlen(pcStr);
-}
diff --git a/drivers/staging/wilc1000/wilc_strutils.h b/drivers/staging/wilc1000/wilc_strutils.h
index 9e3c5d9..7c38e14 100644
--- a/drivers/staging/wilc1000/wilc_strutils.h
+++ b/drivers/staging/wilc1000/wilc_strutils.h
@@ -95,15 +95,5 @@ char *WILC_strncpy(char *pcTarget, const char *pcSource,
 s32 WILC_strncmp(const char *pcStr1, const char *pcStr2,
 			 u32 u32Count);
 
-/*!
- *  @brief	gets the length of a string
- *  @param[in]	pcStr the string
- *  @return	the length
- *  @note	this function repeats the functionality of standard strlen
- *  @author	syounan
- *  @date	18 Aug 2010
- *  @version	1.0
- */
-u32 WILC_strlen(const char *pcStr);
 
 #endif
-- 
1.9.1

