Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:65481 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679AbaJ2R55 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:57:57 -0400
Received: by mail-wg0-f46.google.com with SMTP id x13so2490100wgg.33
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:57:55 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 30/48] staging: vt6655: move all RATE_* macros to device.h
Date: Wed, 29 Oct 2014 17:55:48 +0000
Message-Id: <1414605366-9335-31-git-send-email-tvboxspy@gmail.com> (sfid-20141029_185807_742382_EB2E6761)
In-Reply-To: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
References: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h  | 15 +++++++++++++++
 drivers/staging/vt6655/vntwifi.h | 14 --------------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index a5e5a007..b96d832 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -80,6 +80,21 @@
 
 /*---------------------  Export Definitions -------------------------*/
 
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
+#define MAX_RATE	12
+
 #define MAC_MAX_CONTEXT_REG     (256+128)
 
 #define MAX_MULTICAST_ADDRESS_NUM       32
diff --git a/drivers/staging/vt6655/vntwifi.h b/drivers/staging/vt6655/vntwifi.h
index ad180e0..2ba7713 100644
--- a/drivers/staging/vt6655/vntwifi.h
+++ b/drivers/staging/vt6655/vntwifi.h
@@ -35,20 +35,6 @@
 #include "card.h"
 
 /*---------------------  Export Definitions -------------------------*/
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
-#define MAX_RATE       12
 
 // key CipherSuite
 #define KEY_CTL_WEP         0x00
-- 
2.1.0

