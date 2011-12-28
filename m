Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:3929 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752872Ab1L1A7w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Dec 2011 19:59:52 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: John W Linville <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 7/7] rt2x00: Change RF3853 to RF3053.
Date: Wed, 28 Dec 2011 01:53:24 +0100
Message-Id: <1325033604-26469-8-git-send-email-gwingerde@gmail.com> (sfid-20111228_020010_779940_F338AD47)
In-Reply-To: <1325033604-26469-7-git-send-email-gwingerde@gmail.com>
References: <1325033604-26469-1-git-send-email-gwingerde@gmail.com>
 <1325033604-26469-2-git-send-email-gwingerde@gmail.com>
 <1325033604-26469-3-git-send-email-gwingerde@gmail.com>
 <1325033604-26469-4-git-send-email-gwingerde@gmail.com>
 <1325033604-26469-5-git-send-email-gwingerde@gmail.com>
 <1325033604-26469-6-git-send-email-gwingerde@gmail.com>
 <1325033604-26469-7-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to the latest Ralink vendor drivers, this seems to be the real
RF chipset type.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 4778620..2571a2f 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -50,7 +50,7 @@
  * RF2853 2.4G/5G 3T3R
  * RF3320 2.4G 1T1R(RT3350/RT3370/RT3390)
  * RF3322 2.4G 2T2R(RT3352/RT3371/RT3372/RT3391/RT3392)
- * RF3853 2.4G/5G 3T3R(RT3883/RT3563/RT3573/RT3593/RT3662)
+ * RF3053 2.4G/5G 3T3R(RT3883/RT3563/RT3573/RT3593/RT3662)
  * RF5370 2.4G 1T1R
  * RF5390 2.4G 1T1R
  */
@@ -66,7 +66,7 @@
 #define RF2853				0x000a
 #define RF3320				0x000b
 #define RF3322				0x000c
-#define RF3853				0x000d
+#define RF3053				0x000d
 #define RF5370				0x5370
 #define RF5390				0x5390
 
-- 
1.7.7.4

