Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:32514 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbbIQKCi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 06:02:38 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 2/4] staging: wilc1000: remove warnings on the multiple blank lines uses
Date: Thu, 17 Sep 2015 19:02:18 +0900
Message-ID: <1442484140-13485-3-git-send-email-tony.cho@atmel.com> (sfid-20150917_120324_623692_7CC8AD1A)
In-Reply-To: <1442484140-13485-1-git-send-email-tony.cho@atmel.com>
References: <1442484140-13485-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes the warnings reported by checkpatch.pl
for using multiple blank lines.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan_if.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index cc92dc9..9111491 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -7,7 +7,6 @@
 /*  */
 /* ///////////////////////////////////////////////////////////////////////// */
 
-
 #ifndef WILC_WLAN_IF_H
 #define WILC_WLAN_IF_H
 
@@ -15,11 +14,9 @@
 /* #define MEMORY_STATIC */
 /* #define USE_OLD_SPI_SW */
 
-
 #include "wilc_oswrapper.h"
 #include "linux_wlan_common.h"
 
-
 /********************************************
  *
  *      Debug Flags
@@ -42,7 +39,6 @@
 #define HIF_SPI            BIT(0)
 #define HIF_SDIO_GPIO_IRQ  BIT(2)
 
-
 /********************************************
  *
  *      Tx/Rx Buffer Size Defines
@@ -156,7 +152,6 @@ struct tx_complete_data {
 	struct sk_buff *skb;
 };
 
-
 typedef void (*wilc_tx_complete_func_t)(void *, int);
 
 #define WILC_TX_ERR_NO_BUF (-2)
@@ -392,7 +387,6 @@ typedef enum {
 typedef enum {
 	WID_NIL                            = 0xffff,
 
-
 	/*  BSS Type                                                                                                                                                                            */
 	/*  --------------------------------------------------------------      */
 	/*  Configuration :  Infrastructure    Independent   Access Point                                                                               */
@@ -753,7 +747,6 @@ typedef enum {
 	/*  --------------------------------------------------------------      */
 	WID_11N_TXOP_PROT_DISABLE          = 0x00B0,
 
-
 	WID_TX_POWER_LEVEL_11N             = 0x00B1,
 
 	/* Custom Character WID list */
@@ -827,7 +820,6 @@ typedef enum {
 	WID_MEMORY_ACCESS_32BIT            = 0x201F,
 	WID_RF_REG_VAL                     = 0x2021,
 
-
 	/* NMAC Integer WID list */
 	WID_11N_PHY_ACTIVE_REG_VAL         = 0x2080,
 
@@ -883,8 +875,6 @@ typedef enum {
 	/* BugID 4951: WID toset IP address in firmware */
 	WID_IP_ADDRESS					= 0x3999,
 
-
-
 	/* Custom String WID list */
 
 	/* EMAC Binary WID list */
@@ -899,7 +889,6 @@ typedef enum {
 	/* NMAC Binary WID list */
 	WID_11N_AUTORATE_TABLE             = 0x4080,
 
-
 	/*Added here by Amr - BugID 4134*/
 	WID_SCAN_CHANNEL_LIST                      = 0x4084,
 
@@ -926,5 +915,4 @@ void wilc_bus_set_max_speed(void);
 void wilc_bus_set_default_speed(void);
 u32 wilc_get_chipid(u8 update);
 
-
 #endif
-- 
1.9.1

