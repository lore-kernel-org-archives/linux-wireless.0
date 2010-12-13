Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:45263 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab0LMLkJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 06:40:09 -0500
Received: by mail-ey0-f171.google.com with SMTP id 5so4064715eyg.2
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 03:40:09 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 03/17] rt2x00: Add RF chip definition
Date: Mon, 13 Dec 2010 12:32:22 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201012131231.28313.IvDoorn@gmail.com> <201012131231.59890.IvDoorn@gmail.com>
In-Reply-To: <201012131231.59890.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012131232.23491.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: RA-Jay Hung <jay_hung@ralinktech.com>

Add RF chip definition

Signed-off-by: RA-Jay Hung <jay_hung@ralinktech.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 03f9fa1..9ea0961 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -46,8 +46,11 @@
  * RF2020 2.4G B/G
  * RF3021 2.4G 1T2R
  * RF3022 2.4G 2T2R
- * RF3052 2.4G 2T2R
- * RF3320 2.4G 1T1R
+ * RF3052 2.4G/5G 2T2R
+ * RF2853 2.4G/5G 3T3R
+ * RF3320 2.4G 1T1R(RT3350/RT3370/RT3390)
+ * RF3322 2.4G 2T2R(RT3352/RT3371/RT3372/RT3391/RT3392)
+ * RF3853 2.4G/5G 3T3R(RT3883/RT3563/RT3573/RT3593/RT3662)
  */
 #define RF2820				0x0001
 #define RF2850				0x0002
@@ -58,7 +61,10 @@
 #define RF3021				0x0007
 #define RF3022				0x0008
 #define RF3052				0x0009
+#define RF2853				0x000a
 #define RF3320				0x000b
+#define RF3322				0x000c
+#define RF3853				0x000d
 
 /*
  * Chipset revisions.
-- 
1.7.2.3

