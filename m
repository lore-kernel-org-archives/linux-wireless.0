Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:40931 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab2FPVgi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2012 17:36:38 -0400
Received: by weyu7 with SMTP id u7so2816241wey.19
        for <linux-wireless@vger.kernel.org>; Sat, 16 Jun 2012 14:36:36 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: xose.vazquez@gmail.com, IvDoorn@gmail.com, gwingerde@gmail.com,
	helmut.schaa@googlemail.com, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: [PATCH] wireless: rt2x00: rt2800: remove unsupported rf and chips
Date: Sat, 16 Jun 2012 23:36:32 +0200
Message-Id: <1339882592-17680-1-git-send-email-xose.vazquez@gmail.com> (sfid-20120616_233721_204981_669FFBA8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

removed, no support for:

RF2853 2.4G/5G 3T3R
RF3322 2.4G 2T2R(RT3352/RT3371/RT3372/RT3391/RT3392)
RF3053 2.4G/5G 3T3R(RT3883/RT3563/RT3573/RT3593/RT3662)

RT3593
RT3883

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h |    6 ------
 drivers/net/wireless/rt2x00/rt2x00.h |    2 --
 2 files changed, 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 9348521..b483c23 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -47,10 +47,7 @@
  * RF3021 2.4G 1T2R
  * RF3022 2.4G 2T2R
  * RF3052 2.4G/5G 2T2R
- * RF2853 2.4G/5G 3T3R
  * RF3320 2.4G 1T1R(RT3350/RT3370/RT3390)
- * RF3322 2.4G 2T2R(RT3352/RT3371/RT3372/RT3391/RT3392)
- * RF3053 2.4G/5G 3T3R(RT3883/RT3563/RT3573/RT3593/RT3662)
  * RF5370 2.4G 1T1R
  * RF5390 2.4G 1T1R
  */
@@ -63,10 +60,7 @@
 #define RF3021				0x0007
 #define RF3022				0x0008
 #define RF3052				0x0009
-#define RF2853				0x000a
 #define RF3320				0x000b
-#define RF3322				0x000c
-#define RF3053				0x000d
 #define RF5370				0x5370
 #define RF5372				0x5372
 #define RF5390				0x5390
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 8f75402..0395881 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -189,8 +189,6 @@ struct rt2x00_chip {
 #define RT3090		0x3090	/* 2.4GHz PCIe */
 #define RT3390		0x3390
 #define RT3572		0x3572
-#define RT3593		0x3593
-#define RT3883		0x3883	/* WSOC */
 #define RT5390		0x5390  /* 2.4GHz */
 #define RT5392		0x5392  /* 2.4GHz */
 
-- 
1.7.10.4

