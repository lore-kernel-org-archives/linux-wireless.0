Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36203 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbbIQHs4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 03:48:56 -0400
Received: by padhk3 with SMTP id hk3so13289418pad.3
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2015 00:48:56 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 1/8] staging: wilc1000: remove INLINE macro
Date: Thu, 17 Sep 2015 16:48:42 +0900
Message-Id: <1442476129-14908-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150917_094900_131159_C9EC2E04)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes INLINE macro that is used anymore.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2 : rebase latest staging-testing

 drivers/staging/wilc1000/coreconfigurator.c | 1 -
 drivers/staging/wilc1000/wilc_wlan.c        | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 2fa2790..14e8efc 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -17,7 +17,6 @@
 /*****************************************************************************/
 /* Constants                                                                 */
 /*****************************************************************************/
-#define INLINE static __inline
 #define TAG_PARAM_OFFSET	(MAC_HDR_LEN + TIME_STAMP_LEN + \
 							BEACON_INTERVAL_LEN + CAP_INFO_LEN)
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 4c25179..47fa0f3 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -9,7 +9,6 @@
 
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
-#define INLINE static __inline
 
 /********************************************
  *
-- 
2.5.1

