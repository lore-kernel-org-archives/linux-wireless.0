Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36407 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757732AbbFQH3V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 03:29:21 -0400
Received: by paceq1 with SMTP id eq1so4581405pac.3
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2015 00:29:21 -0700 (PDT)
From: Sunghoon Cho <ywhsbliss@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	chris.park@atmel.com, Rachel.kim@atmel.com, dean.lee@atmel.com
Cc: Sunghoon Cho <ywhsbliss@gmail.com>
Subject: [PATCH 4/5] staging: wilc100: align definitions
Date: Wed, 17 Jun 2015 16:28:54 +0900
Message-Id: <97d83e0878d977d92f10cb28110e3fb459b1ca45.1434526056.git.ywhsbliss@gmail.com> (sfid-20150617_092924_456551_9418003D)
In-Reply-To: <eed9181385a22bfe580dbe1a0cca17d9bb694209.1434526056.git.ywhsbliss@gmail.com>
References: <eed9181385a22bfe580dbe1a0cca17d9bb694209.1434526056.git.ywhsbliss@gmail.com>
In-Reply-To: <eed9181385a22bfe580dbe1a0cca17d9bb694209.1434526056.git.ywhsbliss@gmail.com>
References: <eed9181385a22bfe580dbe1a0cca17d9bb694209.1434526056.git.ywhsbliss@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch alignes the lines of #define preprocessors.

Signed-off-by: Sunghoon Cho <ywhsbliss@gmail.com>
---
 drivers/staging/wilc1000/wilc_wlan_if.h | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 438e2db2..11a3b98 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -107,11 +107,10 @@ typedef struct {
 typedef struct {
 	void (*mac_indicate)(int);
 } wilc_wlan_indicate_func_t;
-#define WILC_MAC_INDICATE_STATUS		0x1
-#define WILC_MAC_STATUS_INIT	-1
-#define WILC_MAC_STATUS_READY 0
-#define WILC_MAC_STATUS_CONNECT 1
-
+#define WILC_MAC_INDICATE_STATUS	0x1
+#define WILC_MAC_STATUS_INIT		-1
+#define WILC_MAC_STATUS_READY		0
+#define WILC_MAC_STATUS_CONNECT		1
 #define WILC_MAC_INDICATE_SCAN		0x2
 
 typedef struct {
@@ -179,7 +178,7 @@ struct tx_complete_data {
 
 typedef void (*wilc_tx_complete_func_t)(void *, int);
 
-#define WILC_TX_ERR_NO_BUF (-2)
+#define WILC_TX_ERR_NO_BUF	(-2)
 
 typedef struct {
 	int (*wlan_firmware_download)(const uint8_t *, uint32_t);
@@ -211,8 +210,7 @@ typedef struct {
 
 #define MAX_SSID_LEN            33
 #define MAX_RATES_SUPPORTED     12
-
-#define INFINITE_SLEEP_TIME		((u32)0xFFFFFFFF)
+#define INFINITE_SLEEP_TIME	((u32)0xFFFFFFFF)
 
 #ifdef WILC_PARSE_SCAN_IN_HOST
 typedef enum {
@@ -266,8 +264,8 @@ typedef enum {
 	G_AUTO_PREAMBLE  = 2,	/* Auto Preamble Selection */
 } G_PREAMBLE_T;
 
-#define MAC_CONNECTED    1
-#define MAC_DISCONNECTED 0
+#define MAC_CONNECTED		1
+#define MAC_DISCONNECTED	0
 
 /* bug3819: */
 #define SCAN_DONE		TRUE
-- 
1.9.1

