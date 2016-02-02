Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:36490 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbcBBA23 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 19:28:29 -0500
Received: by mail-pa0-f66.google.com with SMTP id ho8so629208pac.3
        for <linux-wireless@vger.kernel.org>; Mon, 01 Feb 2016 16:28:28 -0800 (PST)
From: Rakhi Sharma <rakhish1994@gmail.com>
To: joe@perches.com, Jes.Sorensen@redhat.com
Cc: gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	Rakhi Sharma <rakhish1994@gmail.com>
Subject: [PATCH v2 5/5] Staging: rtl8723au: core: rtw_ieee80211: Fixed a coding style Warning.
Date: Tue,  2 Feb 2016 05:58:12 +0530
Message-Id: <1454372892-4962-1-git-send-email-rakhish1994@gmail.com> (sfid-20160202_012832_066894_79D3AB1D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed a braces style warning.
Warning: braces {} are not necessary for single statement blocks.

Signed-off-by: Rakhi Sharma <rakhish1994@gmail.com>
---
Changes in v2:
  - remove a blank line. To make it readable.
---
 drivers/staging/rtl8723au/core/rtw_ieee80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_ieee80211.c b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
index 365f780..55a5078 100644
--- a/drivers/staging/rtl8723au/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
@@ -177,8 +177,8 @@ u8 *rtw_get_ie23a(u8 *pbuf, int index, int *len, int limit)
 	u8 *p;
 
 	if (limit < 1)
-
 		return NULL;
+
 	p = pbuf;
 	i = 0;
 	*len = 0;
-- 
1.9.1

