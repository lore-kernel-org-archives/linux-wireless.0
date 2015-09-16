Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33265 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbbIPLLs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 07:11:48 -0400
Received: by pacex6 with SMTP id ex6so207190545pac.0
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2015 04:11:48 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 03/10] staging: wilc1000: remove INLINE macro
Date: Wed, 16 Sep 2015 20:11:28 +0900
Message-Id: <1442401895-7463-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20150916_131151_446043_D6B11E59)
In-Reply-To: <1442401895-7463-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442401895-7463-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes INLINE macro that is used anymore.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 1 -
 drivers/staging/wilc1000/wilc_wlan.c        | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 9605517..f15ca3b 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -16,7 +16,6 @@
 /*****************************************************************************/
 /* Constants                                                                 */
 /*****************************************************************************/
-#define INLINE static __inline
 #define PHY_802_11n
 #define MAX_CFG_PKTLEN     1450
 #define MSG_HEADER_LEN     4
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 4ea7de4..a3e6973 100644
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

