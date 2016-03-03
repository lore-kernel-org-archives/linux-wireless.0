Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:33662 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbcCCF2l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 00:28:41 -0500
Received: by mail-pa0-f66.google.com with SMTP id gc2so55026pab.0
        for <linux-wireless@vger.kernel.org>; Wed, 02 Mar 2016 21:28:40 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 4/5] staging: wilc1000: remove unused define
Date: Thu,  3 Mar 2016 14:28:23 +0900
Message-Id: <1456982904-8063-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20160303_062859_025936_1DAAE819)
In-Reply-To: <1456982904-8063-1-git-send-email-chaehyun.lim@gmail.com>
References: <1456982904-8063-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes INFINITE_SLEEP_TIME that is not used in the driver,
so just remove it.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wlan_if.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 9eb123b..83cf84d 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -96,8 +96,6 @@ typedef void (*wilc_tx_complete_func_t)(void *, int);
 #define MAX_SSID_LEN            33
 #define MAX_RATES_SUPPORTED     12
 
-#define INFINITE_SLEEP_TIME	((u32)0xFFFFFFFF)
-
 typedef enum {
 	SUPP_RATES_IE		= 1,
 	EXT_SUPP_RATES_IE	= 50,
-- 
2.7.1

