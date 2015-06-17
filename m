Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33687 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757565AbbFQFnA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 01:43:00 -0400
Received: by padev16 with SMTP id ev16so27151807pad.0
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2015 22:42:59 -0700 (PDT)
From: Sunghoon Cho <ywhsbliss@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	chris.park@atmel.com, Rachel.kim@atmel.com, dean.lee@atmel.com
Cc: Sunghoon Cho <ywhsbliss@gmail.com>
Subject: [PATCH 3/5] staging: wilc1000: remove the warnings on line over 80 characters.
Date: Wed, 17 Jun 2015 14:42:34 +0900
Message-Id: <96ea4637a566933afbba83499d2e4ab0ed75355c.1434519635.git.ywhsbliss@gmail.com> (sfid-20150617_074304_082757_8E98CC89)
In-Reply-To: <99c95a41549a43582fd1c679c34723d54771cbcc.1434519635.git.ywhsbliss@gmail.com>
References: <99c95a41549a43582fd1c679c34723d54771cbcc.1434519635.git.ywhsbliss@gmail.com>
In-Reply-To: <99c95a41549a43582fd1c679c34723d54771cbcc.1434519635.git.ywhsbliss@gmail.com>
References: <99c95a41549a43582fd1c679c34723d54771cbcc.1434519635.git.ywhsbliss@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes the warnings reported by checkpatch.pl for line over 80
characters.

Signed-off-by: Sunghoon Cho <ywhsbliss@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 7f58551..96e4d5c 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -77,8 +77,8 @@ struct WILC_WFI_stats {
 #define num_reg_frame 2
 /*
  * If you use RX_BH_WORK_QUEUE on LPC3131: You may lose the first interrupt on
- * LPC3131 which is important to get the MAC start status when you are blocked inside
- * linux_wlan_firmware_download() which blocks mac_open().
+ * LPC3131 which is important to get the MAC start status when you are blocked
+ * inside linux_wlan_firmware_download() which blocks mac_open().
  */
 #if defined (NM73131_0_BOARD)
  #define RX_BH_TYPE  RX_BH_KTHREAD
@@ -150,7 +150,8 @@ struct WILC_WFI_priv {
 	u8 WILC_WFI_wep_default;
 	u8 WILC_WFI_wep_key[4][WLAN_KEY_LEN_WEP104];
 	u8 WILC_WFI_wep_key_len[4];
-	struct net_device *real_ndev;   /* The real interface that the monitor is on */
+	/* The real interface that the monitor is on  */
+	struct net_device *real_ndev;
 	struct wilc_wfi_key *wilc_gtk[MAX_NUM_STA];
 	struct wilc_wfi_key *wilc_ptk[MAX_NUM_STA];
 	u8 wilc_groupkey;
-- 
1.9.1

