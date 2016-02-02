Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36407 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbcBBMna (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 07:43:30 -0500
Received: by mail-pf0-f195.google.com with SMTP id n128so8984107pfn.3
        for <linux-wireless@vger.kernel.org>; Tue, 02 Feb 2016 04:43:30 -0800 (PST)
From: Rakhi Sharma <rakhish1994@gmail.com>
To: joe@perches.com, Jes.Sorensen@redhat.com, julian.calaby@gmail.com
Cc: linux-wireless@vger.kernel.org,
	Rakhi Sharma <rakhish1994@gmail.com>
Subject: [PATCH] Staging: rtl8723au: core: rtw_ieee80211: Fixed a coding style Warning.
Date: Tue,  2 Feb 2016 18:13:12 +0530
Message-Id: <1454416992-7400-1-git-send-email-rakhish1994@gmail.com> (sfid-20160202_134333_703771_FDF7D13A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed a braces style warning.
Warning: braces {} are not necessary for single statement blocks.

Signed-off-by: Rakhi Sharma <rakhish1994@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_ieee80211.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_ieee80211.c b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
index 07a6490..5089ae8 100644
--- a/drivers/staging/rtl8723au/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
@@ -176,10 +176,8 @@ u8 *rtw_get_ie23a(u8 *pbuf, int index, int *len, int limit)
 	int tmp, i;
 	u8 *p;
 
-	if (limit < 1) {
-
+	if (limit < 1)
 		return NULL;
-	}
 
 	p = pbuf;
 	i = 0;
-- 
1.9.1

