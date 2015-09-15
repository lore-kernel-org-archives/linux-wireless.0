Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33279 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbbIOFHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 01:07:30 -0400
Received: by pacex6 with SMTP id ex6so165324206pac.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2015 22:07:30 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 13/18] staging: wilc1000: fix alignment of enum
Date: Tue, 15 Sep 2015 14:06:23 +0900
Message-Id: <1442293588-15323-13-git-send-email-chaehyun.lim@gmail.com> (sfid-20150915_070739_195542_D317C2C4)
In-Reply-To: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fix alignment of enum.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.h | 76 +++++++++++++++----------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 64bcd80..e3e4b06 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -77,13 +77,13 @@ typedef struct _tstrStatistics {
 
 
 typedef enum {
-	HOST_IF_IDLE					= 0,
-	HOST_IF_SCANNING				= 1,
-	HOST_IF_CONNECTING				= 2,
-	HOST_IF_WAITING_CONN_RESP		= 3,
-	HOST_IF_CONNECTED				= 4,
-	HOST_IF_P2P_LISTEN				= 5,
-	HOST_IF_FORCE_32BIT			= 0xFFFFFFFF
+	HOST_IF_IDLE			= 0,
+	HOST_IF_SCANNING		= 1,
+	HOST_IF_CONNECTING		= 2,
+	HOST_IF_WAITING_CONN_RESP	= 3,
+	HOST_IF_CONNECTED		= 4,
+	HOST_IF_P2P_LISTEN		= 5,
+	HOST_IF_FORCE_32BIT		= 0xFFFFFFFF
 } tenuHostIFstate;
 
 typedef struct _tstrHostIFpmkid {
@@ -97,19 +97,19 @@ typedef struct _tstrHostIFpmkidAttr {
 } tstrHostIFpmkidAttr;
 
 typedef enum {
-	AUTORATE	 = 0,
-	MBPS_1	     = 1,
-	MBPS_2	     = 2,
-	MBPS_5_5	     = 5,
-	MBPS_11	     = 11,
-	MBPS_6	     = 6,
-	MBPS_9	     = 9,
-	MBPS_12	     = 12,
-	MBPS_18	     = 18,
-	MBPS_24	     = 24,
-	MBPS_36	     = 36,
-	MBPS_48	     = 48,
-	MBPS_54	     = 54
+	AUTORATE	= 0,
+	MBPS_1		= 1,
+	MBPS_2		= 2,
+	MBPS_5_5	= 5,
+	MBPS_11		= 11,
+	MBPS_6		= 6,
+	MBPS_9		= 9,
+	MBPS_12		= 12,
+	MBPS_18		= 18,
+	MBPS_24		= 24,
+	MBPS_36		= 36,
+	MBPS_48		= 48,
+	MBPS_54		= 54
 } CURRENT_TX_RATE_T;
 
 typedef struct {
@@ -140,23 +140,23 @@ typedef struct {
 typedef enum {
 	RETRY_SHORT		= 1 << 0,
 	RETRY_LONG		= 1 << 1,
-	FRAG_THRESHOLD	= 1 << 2,
-	RTS_THRESHOLD	= 1 << 3,
-	BSS_TYPE  = 1 << 4,
-	AUTH_TYPE = 1 << 5,
-	AUTHEN_TIMEOUT = 1 << 6,
-	POWER_MANAGEMENT = 1 << 7,
-	PREAMBLE = 1 << 8,
-	SHORT_SLOT_ALLOWED = 1 << 9,
-	TXOP_PROT_DISABLE = 1 << 10,
-	BEACON_INTERVAL = 1 << 11,
-	DTIM_PERIOD = 1 << 12,
-	SITE_SURVEY = 1 << 13,
-	SITE_SURVEY_SCAN_TIME = 1 << 14,
-	ACTIVE_SCANTIME = 1 << 15,
-	PASSIVE_SCANTIME = 1 << 16,
-	CURRENT_TX_RATE = 1 << 17,
-	HT_ENABLE = 1 << 18,
+	FRAG_THRESHOLD		= 1 << 2,
+	RTS_THRESHOLD		= 1 << 3,
+	BSS_TYPE		= 1 << 4,
+	AUTH_TYPE		= 1 << 5,
+	AUTHEN_TIMEOUT		= 1 << 6,
+	POWER_MANAGEMENT	= 1 << 7,
+	PREAMBLE		= 1 << 8,
+	SHORT_SLOT_ALLOWED	= 1 << 9,
+	TXOP_PROT_DISABLE	= 1 << 10,
+	BEACON_INTERVAL		= 1 << 11,
+	DTIM_PERIOD		= 1 << 12,
+	SITE_SURVEY		= 1 << 13,
+	SITE_SURVEY_SCAN_TIME	= 1 << 14,
+	ACTIVE_SCANTIME		= 1 << 15,
+	PASSIVE_SCANTIME	= 1 << 16,
+	CURRENT_TX_RATE		= 1 << 17,
+	HT_ENABLE		= 1 << 18,
 } tenuCfgParam;
 
 typedef struct {
@@ -172,7 +172,7 @@ typedef enum {SCAN_EVENT_NETWORK_FOUND  = 0,
 typedef enum {
 	CONN_DISCONN_EVENT_CONN_RESP		= 0,
 	CONN_DISCONN_EVENT_DISCONN_NOTIF	= 1,
-	CONN_DISCONN_EVENT_FORCE_32BIT	 = 0xFFFFFFFF
+	CONN_DISCONN_EVENT_FORCE_32BIT		= 0xFFFFFFFF
 } tenuConnDisconnEvent;
 
 typedef enum {
-- 
2.5.1

