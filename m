Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37726 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031547AbbKFCR6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:17:58 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 59/73] staging: wilc1000: fixes please don't use multiple blank lines
Date: Fri, 6 Nov 2015 11:19:58 +0900
Message-ID: <1446776412-30670-10-git-send-email-glen.lee@atmel.com> (sfid-20151106_031801_043661_0D749F2D)
In-Reply-To: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
References: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the checks reported by checkpatch.pl
for Please don't use multiple blank lines.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 6ca2544..74f6210 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -1,11 +1,7 @@
 #ifndef WILC_WLAN_H
 #define WILC_WLAN_H
 
-
-
 #define ISWILC1000(id)			((id & 0xfffff000) == 0x100000 ? 1 : 0)
-
-
 /********************************************
  *
  *      Mac eth header length
@@ -140,8 +136,6 @@
 #else
 #define WILC_PLL_TO		2
 #endif
-
-
 #define ABORT_INT		BIT(31)
 
 /*******************************************/
@@ -203,8 +197,6 @@
 
 #define ENABLE_RX_VMM		(SEL_VMM_TBL1 | EN_VMM)
 #define ENABLE_TX_VMM		(SEL_VMM_TBL0 | EN_VMM)
-
-
 /*time for expiring the semaphores of cfg packets*/
 #define CFG_PKTS_TIMEOUT	2000
 /********************************************
-- 
1.9.1

