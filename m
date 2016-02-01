Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35550 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbcBAMwC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 07:52:02 -0500
Received: by mail-pf0-f194.google.com with SMTP id 66so7075451pfe.2
        for <linux-wireless@vger.kernel.org>; Mon, 01 Feb 2016 04:52:01 -0800 (PST)
From: Rakhi Sharma <rakhish1994@gmail.com>
To: Jes.Sorensen@redhat.com, gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Rakhi Sharma <rakhish1994@gmail.com>
Subject: [PATCH 4/4] Staging: rtl8723au: core: rtw_ieee80211: Fixed a coding style Warning.
Date: Mon,  1 Feb 2016 18:21:44 +0530
Message-Id: <1454331104-16835-1-git-send-email-rakhish1994@gmail.com> (sfid-20160201_135206_578686_E7D7C0FC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed a braces style warning.
Warning: braces {} are not necessary for single statement blocks.

Signed-off-by: Rakhi Sharma <rakhish1994@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_ieee80211.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_ieee80211.c b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
index 0c933e4..365f780 100644
--- a/drivers/staging/rtl8723au/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
@@ -176,11 +176,9 @@ u8 *rtw_get_ie23a(u8 *pbuf, int index, int *len, int limit)
 	int tmp, i;
 	u8 *p;
 
-	if (limit < 1) {
+	if (limit < 1)
 
 		return NULL;
-	}
-
 	p = pbuf;
 	i = 0;
 	*len = 0;
-- 
1.9.1

