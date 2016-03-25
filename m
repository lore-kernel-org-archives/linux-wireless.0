Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:49918 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbcCYMUk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2016 08:20:40 -0400
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 09/11] staging: wilc1000: removes unused define
Date: Fri, 25 Mar 2016 21:16:54 +0900
Message-ID: <1458908216-12100-9-git-send-email-leo.kim@atmel.com> (sfid-20160325_132043_184678_A911372A)
In-Reply-To: <1458908216-12100-1-git-send-email-leo.kim@atmel.com>
References: <1458908216-12100-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unused define.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c   | 2 --
 drivers/staging/wilc1000/wilc_wlan_if.h | 9 ---------
 2 files changed, 11 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 8f0a74d..127a967 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -30,8 +30,6 @@ static struct notifier_block g_dev_notifier = {
 	.notifier_call = dev_state_ev_handler
 };
 
-#define IRQ_WAIT	1
-#define IRQ_NO_WAIT	0
 static struct semaphore close_exit_sync;
 
 static int wlan_deinit_locks(struct net_device *dev);
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 119b313..410bfc0 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -25,15 +25,6 @@
 
 /********************************************
  *
- *      Tx/Rx Buffer Size Defines
- *
- ********************************************/
-
-#define CE_TX_BUFFER_SIZE	(64 * 1024)
-#define CE_RX_BUFFER_SIZE	(384 * 1024)
-
-/********************************************
- *
  *      Wlan Interface Defines
  *
  ********************************************/
-- 
1.9.1

