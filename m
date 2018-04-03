Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:46447 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752813AbeDCXhR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 19:37:17 -0400
Received: by mail-qt0-f193.google.com with SMTP id h4so21230670qtn.13
        for <linux-wireless@vger.kernel.org>; Tue, 03 Apr 2018 16:37:17 -0700 (PDT)
From: Joao Dalben <jhdalben@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, lkcamp@lists.libreplanetbr.org,
        Joao Dalben <jhdalben@gmail.com>
Subject: [PATCH] staging: rtl8192e: Fixed coding style around a plus sign
Date: Tue,  3 Apr 2018 20:36:43 -0300
Message-Id: <20180403233643.9642-1-jhdalben@gmail.com> (sfid-20180404_013721_752017_7F11120E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added blank spaces between a plus sign in order to standardize the coding
style.

Signed-off-by: Joao Dalben <jhdalben@gmail.com>
---
 drivers/staging/rtl8192e/dot11d.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192e/dot11d.c b/drivers/staging/rtl8192e/dot11d.c
index 88f89d77b511..a1c096124683 100644
--- a/drivers/staging/rtl8192e/dot11d.c
+++ b/drivers/staging/rtl8192e/dot11d.c
@@ -50,7 +50,7 @@ void dot11d_init(struct rtllib_device *ieee)
 
 	pDot11dInfo->State = DOT11D_STATE_NONE;
 	pDot11dInfo->CountryIeLen = 0;
-	memset(pDot11dInfo->channel_map, 0, MAX_CHANNEL_NUMBER+1);
+	memset(pDot11dInfo->channel_map, 0, MAX_CHANNEL_NUMBER + 1);
 	memset(pDot11dInfo->MaxTxPwrDbmList, 0xFF, MAX_CHANNEL_NUMBER + 1);
 	RESET_CIE_WATCHDOG(ieee);
 }
-- 
2.11.0
