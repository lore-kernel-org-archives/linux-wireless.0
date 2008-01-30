Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:51432 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356AbYA3ATp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2008 19:19:45 -0500
Message-ID: <479FC29C.103@tiscali.nl> (sfid-20080130_001952_434169_7ED3509E)
Date: Wed, 30 Jan 2008 01:19:40 +0100
From: Roel Kluin <12o3l@tiscali.nl>
MIME-Version: 1.0
To: flamingice@sourmilk.net
CC: linux-wireless@vger.kernel.org
Subject: [PATCH] [wireless/adm8211.h] logical/bitor typo
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

logical/bitor typo

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/net/wireless/adm8211.h b/drivers/net/wireless/adm8211.h
index ef326fe..55ac768 100644
--- a/drivers/net/wireless/adm8211.h
+++ b/drivers/net/wireless/adm8211.h
@@ -266,7 +266,7 @@ do {								\
 #define ADM8211_SYNCTL_CS1	(1 << 28)
 #define ADM8211_SYNCTL_CAL	(1 << 27)
 #define ADM8211_SYNCTL_SELCAL	(1 << 26)
-#define ADM8211_SYNCTL_RFtype	((1 << 24) || (1 << 23) || (1 << 22))
+#define ADM8211_SYNCTL_RFtype	((1 << 24) | (1 << 23) | (1 << 22))
 #define ADM8211_SYNCTL_RFMD	(1 << 22)
 #define ADM8211_SYNCTL_GENERAL	(0x7 << 22)
 /* SYNCTL 21:0 Data (Si4126: 18-bit data, 4-bit address) */
