Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:32869 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbbFZGt1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2015 02:49:27 -0400
Received: by pdjn11 with SMTP id n11so69308810pdj.0
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2015 23:49:27 -0700 (PDT)
From: Sunghoon Cho <ywhsbliss@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, chris.park@atmel.com, Rachel.kim@atmel.com,
	dean.lee@atmel.com, ywhsbliss@gmail.com
Subject: [PATCH 3/3] staging: wilc1000: remove the warnings on the line over 80 characters
Date: Fri, 26 Jun 2015 15:48:16 +0900
Message-Id: <2337e747eb6df9df5287e1866ef26ddc41dcbedb.1435300603.git.ywhsbliss@gmail.com> (sfid-20150626_084931_014088_31C89A52)
In-Reply-To: <41da67d312f5ddf70e2a401814df494d71c8a945.1435300603.git.ywhsbliss@gmail.com>
References: <41da67d312f5ddf70e2a401814df494d71c8a945.1435300603.git.ywhsbliss@gmail.com>
In-Reply-To: <41da67d312f5ddf70e2a401814df494d71c8a945.1435300603.git.ywhsbliss@gmail.com>
References: <41da67d312f5ddf70e2a401814df494d71c8a945.1435300603.git.ywhsbliss@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the warnings reported by checkpatch.pl on the line
over 80 characters.

Signed-off-by: Sunghoon Cho <ywhsbliss@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 8102ef0..0dfe108 100644
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
 #if defined(NM73131_0_BOARD)
  #define RX_BH_TYPE  RX_BH_KTHREAD
@@ -151,7 +151,8 @@ struct WILC_WFI_priv {
 	u8 WILC_WFI_wep_default;
 	u8 WILC_WFI_wep_key[4][WLAN_KEY_LEN_WEP104];
 	u8 WILC_WFI_wep_key_len[4];
-	struct net_device *real_ndev;   /* The real interface that the monitor is on */
+	/* The real interface that the monitor is on */
+	struct net_device *real_ndev;
 	struct wilc_wfi_key *wilc_gtk[MAX_NUM_STA];
 	struct wilc_wfi_key *wilc_ptk[MAX_NUM_STA];
 	u8 wilc_groupkey;
-- 
1.9.1

