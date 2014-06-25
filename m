Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:60153 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685AbaFYUPh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:15:37 -0400
Received: by mail-we0-f181.google.com with SMTP id q59so2678440wes.40
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:15:36 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 13/17] staging: vt6656: mac80211 conversion: move data rates to device.h
Date: Wed, 25 Jun 2014 21:14:34 +0100
Message-Id: <1403727278-6666-14-git-send-email-tvboxspy@gmail.com> (sfid-20140625_223005_304043_B549230B)
In-Reply-To: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
References: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move all RATE_* macros to device.h

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/datarate.h | 14 --------------
 drivers/staging/vt6656/device.h   | 14 ++++++++++++++
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/vt6656/datarate.h b/drivers/staging/vt6656/datarate.h
index 96252ad..19b2c66 100644
--- a/drivers/staging/vt6656/datarate.h
+++ b/drivers/staging/vt6656/datarate.h
@@ -39,20 +39,6 @@
 #define RETRY_TIMES_THRD_H         2    /* times */
 #define RETRY_TIMES_THRD_L         1    /* times */
 
-#define RATE_1M         0
-#define RATE_2M         1
-#define RATE_5M         2
-#define RATE_11M        3
-#define RATE_6M         4
-#define RATE_9M         5
-#define RATE_12M        6
-#define RATE_18M        7
-#define RATE_24M        8
-#define RATE_36M        9
-#define RATE_48M       10
-#define RATE_54M       11
-#define RATE_AUTO      12
-
 void RATEvParseMaxRate(struct vnt_private *, PWLAN_IE_SUPP_RATES pItemRates,
 	PWLAN_IE_SUPP_RATES pItemExtRates, int bUpdateBasicRate,
 	u16 *pwMaxBasicRate, u16 *pwMaxSuppRate, u16 *pwSuppRate,
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 2bd9830..6696365 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -53,6 +53,20 @@
 #undef DEVICE_ETHTOOL_IOCTL_SUPPORT
 #endif
 
+#define RATE_1M		0
+#define RATE_2M		1
+#define RATE_5M		2
+#define RATE_11M	3
+#define RATE_6M		4
+#define RATE_9M		5
+#define RATE_12M	6
+#define RATE_18M	7
+#define RATE_24M	8
+#define RATE_36M	9
+#define RATE_48M	10
+#define RATE_54M	11
+#define RATE_AUTO	12
+
 #define MAX_RATE			12
 
 /*
-- 
1.9.1

