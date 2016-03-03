Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36412 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945AbcCCMGX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 07:06:23 -0500
Received: by mail-pf0-f196.google.com with SMTP id q129so1202186pfb.3
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2016 04:06:22 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 3/6] staging: wilc1000: rename hardwareProductVersion in struct wilc_mac_cfg
Date: Thu,  3 Mar 2016 21:05:19 +0900
Message-Id: <1457006722-14400-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20160303_130625_739593_B7AD828A)
In-Reply-To: <1457006722-14400-1-git-send-email-chaehyun.lim@gmail.com>
References: <1457006722-14400-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames hardwareProductVersion to hw_product_version to avoid
camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index b25d772..6a33187 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -29,7 +29,7 @@ struct wilc_mac_cfg {
 	u8 supp_rate[24];
 	u8 wep_key[28];
 	u8 i_psk[66];
-	u8 hardwareProductVersion[33];
+	u8 hw_product_version[33];
 	u8 phyversion[17];
 	u8 supp_username[21];
 	u8 supp_password[64];
@@ -136,7 +136,7 @@ static struct wilc_cfg_str g_cfg_str[] = {
 	{WID_BSSID, g_mac.bssid},	/* 6 bytes */
 	{WID_WEP_KEY_VALUE, g_mac.wep_key},	/* 27 bytes */
 	{WID_11I_PSK, g_mac.i_psk},	/* 65 bytes */
-	{WID_HARDWARE_VERSION, g_mac.hardwareProductVersion},
+	{WID_HARDWARE_VERSION, g_mac.hw_product_version},
 	{WID_MAC_ADDR, g_mac.mac_address},
 	{WID_PHY_VERSION, g_mac.phyversion},
 	{WID_SUPP_USERNAME, g_mac.supp_username},
-- 
2.7.1

