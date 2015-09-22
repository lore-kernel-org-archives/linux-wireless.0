Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:28228 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756941AbbIVFcf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 01:32:35 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v3 2/4] staging: wilc1000: wilc_wlan_if.h: remove warnings on the multiple blank lines
Date: Tue, 22 Sep 2015 14:34:44 +0900
Message-ID: <1442900086-9480-2-git-send-email-glen.lee@atmel.com> (sfid-20150922_073237_881340_66124EDE)
In-Reply-To: <1442900086-9480-1-git-send-email-glen.lee@atmel.com>
References: <1442900086-9480-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes the warnings reported by checkpatch.pl
for using multiple blank lines.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan_if.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 5f68b6a..e56014d 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -7,18 +7,15 @@
 /*  */
 /* ///////////////////////////////////////////////////////////////////////// */
 
-
 #ifndef WILC_WLAN_IF_H
 #define WILC_WLAN_IF_H
 
 /* #define MEMORY_STATIC */
 /* #define USE_OLD_SPI_SW */
 
-
 #include "wilc_oswrapper.h"
 #include "linux_wlan_common.h"
 
-
 /********************************************
  *
  *      Debug Flags
@@ -41,7 +38,6 @@
 #define HIF_SPI            BIT(0)
 #define HIF_SDIO_GPIO_IRQ  BIT(2)
 
-
 /********************************************
  *
  *      Tx/Rx Buffer Size Defines
@@ -154,7 +150,6 @@ struct tx_complete_data {
 	struct sk_buff *skb;
 };
 
-
 typedef void (*wilc_tx_complete_func_t)(void *, int);
 
 #define WILC_TX_ERR_NO_BUF (-2)
@@ -388,7 +383,6 @@ typedef enum {
 typedef enum {
 	WID_NIL                            = 0xffff,
 
-
 	/*  BSS Type                                                                                                                                                                            */
 	/*  --------------------------------------------------------------      */
 	/*  Configuration :  Infrastructure    Independent   Access Point                                                                               */
@@ -748,7 +742,6 @@ typedef enum {
 	/*  --------------------------------------------------------------      */
 	WID_11N_TXOP_PROT_DISABLE          = 0x00B0,
 
-
 	WID_TX_POWER_LEVEL_11N             = 0x00B1,
 
 	/* Custom Character WID list */
@@ -821,7 +814,6 @@ typedef enum {
 	WID_MEMORY_ACCESS_32BIT            = 0x201F,
 	WID_RF_REG_VAL                     = 0x2021,
 
-
 	/* NMAC Integer WID list */
 	WID_11N_PHY_ACTIVE_REG_VAL         = 0x2080,
 
@@ -874,8 +866,6 @@ typedef enum {
 
 	WID_IP_ADDRESS					= 0x3999,
 
-
-
 	/* Custom String WID list */
 
 	/* EMAC Binary WID list */
@@ -890,7 +880,6 @@ typedef enum {
 	/* NMAC Binary WID list */
 	WID_11N_AUTORATE_TABLE             = 0x4080,
 
-
 	WID_SCAN_CHANNEL_LIST                      = 0x4084,
 
 	WID_INFO_ELEMENT_PROBE	 = 0x4085,
@@ -913,5 +902,4 @@ void wilc_bus_set_max_speed(void);
 void wilc_bus_set_default_speed(void);
 u32 wilc_get_chipid(u8 update);
 
-
 #endif
-- 
1.9.1

