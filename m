Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:36748 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbcCCMGT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 07:06:19 -0500
Received: by mail-pa0-f68.google.com with SMTP id a7so1147916pax.3
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2016 04:06:19 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/6] staging: wilc1000: remove commented codes
Date: Thu,  3 Mar 2016 21:05:18 +0900
Message-Id: <1457006722-14400-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20160303_130622_636911_39F74E14)
In-Reply-To: <1457006722-14400-1-git-send-email-chaehyun.lim@gmail.com>
References: <1457006722-14400-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes commented codes in struct wilc_cfg_str.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index b992243..b25d772 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -136,7 +136,6 @@ static struct wilc_cfg_str g_cfg_str[] = {
 	{WID_BSSID, g_mac.bssid},	/* 6 bytes */
 	{WID_WEP_KEY_VALUE, g_mac.wep_key},	/* 27 bytes */
 	{WID_11I_PSK, g_mac.i_psk},	/* 65 bytes */
-	/* {WID_11E_P_ACTION_REQ, g_mac.action_req}, */
 	{WID_HARDWARE_VERSION, g_mac.hardwareProductVersion},
 	{WID_MAC_ADDR, g_mac.mac_address},
 	{WID_PHY_VERSION, g_mac.phyversion},
@@ -144,10 +143,8 @@ static struct wilc_cfg_str g_cfg_str[] = {
 	{WID_SUPP_PASSWORD, g_mac.supp_password},
 	{WID_SITE_SURVEY_RESULTS, g_mac.scan_result},
 	{WID_SITE_SURVEY_RESULTS, g_mac.scan_result1},
-	/* {WID_RX_POWER_LEVEL, g_mac.channel_rssi}, */
 	{WID_ASSOC_REQ_INFO, g_mac.assoc_req},
 	{WID_ASSOC_RES_INFO, g_mac.assoc_rsp},
-	/* {WID_11N_P_ACTION_REQ, g_mac.action_req}, */
 	{WID_FIRMWARE_INFO, g_mac.firmware_version},
 	{WID_IP_ADDRESS, g_mac.ip_address},
 	{WID_NIL, NULL}
-- 
2.7.1

