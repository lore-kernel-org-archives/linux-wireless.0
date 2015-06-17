Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34774 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824AbbFQH3M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 03:29:12 -0400
Received: by pacgb13 with SMTP id gb13so29044675pac.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2015 00:29:12 -0700 (PDT)
From: Sunghoon Cho <ywhsbliss@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	chris.park@atmel.com, Rachel.kim@atmel.com, dean.lee@atmel.com
Cc: Sunghoon Cho <ywhsbliss@gmail.com>
Subject: [PATCH 2/5] staging: wilc1000: remove the warnings on multiple blank line uses.
Date: Wed, 17 Jun 2015 16:28:52 +0900
Message-Id: <8780894482d8ada4d46da9e008945a5bd03e12fe.1434526056.git.ywhsbliss@gmail.com> (sfid-20150617_092917_436596_0AF0F63D)
In-Reply-To: <eed9181385a22bfe580dbe1a0cca17d9bb694209.1434526056.git.ywhsbliss@gmail.com>
References: <eed9181385a22bfe580dbe1a0cca17d9bb694209.1434526056.git.ywhsbliss@gmail.com>
In-Reply-To: <eed9181385a22bfe580dbe1a0cca17d9bb694209.1434526056.git.ywhsbliss@gmail.com>
References: <eed9181385a22bfe580dbe1a0cca17d9bb694209.1434526056.git.ywhsbliss@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the warnings reported by checkpatch.pl regarding
the multiple blank line.

Signed-off-by: Sunghoon Cho <ywhsbliss@gmail.com>
---
 drivers/staging/wilc1000/wilc_wlan_if.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index c7143cd..33d70c6 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -3,7 +3,6 @@
  * Module Name:  wilc_wlan_if.h
  */
 
-
 #ifndef WILC_WLAN_IF_H
 #define WILC_WLAN_IF_H
 
@@ -15,11 +14,9 @@
 /* #define WILC_FULLY_HOSTING_AP */
 /* #define USE_OLD_SPI_SW */
 
-
 #include "wilc_type.h"
 #include "linux_wlan_common.h"
 
-
 /* Debug Flags */
 
 #define N_INIT		0x00000001
@@ -34,7 +31,6 @@
 #define HIF_SPI            (1 << 0)
 #define HIF_SDIO_GPIO_IRQ  (1 << 2)
 
-
 /* Tx/Rx Buffer Size Defines */
 
 #define CE_TX_BUFFER_SIZE (64 * 1024)
@@ -181,7 +177,6 @@ struct tx_complete_data {
 	struct sk_buff *skb;
 };
 
-
 typedef void (*wilc_tx_complete_func_t)(void *, int);
 
 #define WILC_TX_ERR_NO_BUF (-2)
@@ -423,7 +418,6 @@ typedef enum {
 typedef enum {
 	WID_NIL                            = 0xffff,
 
-
 	/*
 	 *  BSS Type
 	 *  --------------------------------------------------------------
@@ -874,7 +868,6 @@ typedef enum {
 	 */
 	WID_11N_TXOP_PROT_DISABLE          = 0x00B0,
 
-
 	WID_TX_POWER_LEVEL_11N             = 0x00B1,
 
 	/* Custom Character WID list */
@@ -954,7 +947,6 @@ typedef enum {
 	WID_MEMORY_ACCESS_32BIT            = 0x201F,
 	WID_RF_REG_VAL                     = 0x2021,
 
-
 	/* NMAC Integer WID list */
 	WID_11N_PHY_ACTIVE_REG_VAL         = 0x2080,
 
@@ -1017,8 +1009,6 @@ typedef enum {
 	/* BugID 4951: WID toset IP address in firmware */
 	WID_IP_ADDRESS					= 0x3999,
 
-
-
 	/* Custom String WID list */
 
 	/* EMAC Binary WID list */
@@ -1033,7 +1023,6 @@ typedef enum {
 	/* NMAC Binary WID list */
 	WID_11N_AUTORATE_TABLE             = 0x4080,
 
-
 	/* Added here by Amr - BugID 4134 */
 	WID_SCAN_CHANNEL_LIST                      = 0x4084,
 
@@ -1060,5 +1049,4 @@ void wilc_bus_set_max_speed(void);
 void wilc_bus_set_default_speed(void);
 uint32_t wilc_get_chipid(uint8_t update);
 
-
 #endif
-- 
1.9.1

