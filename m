Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35547 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757564AbbFQFmv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 01:42:51 -0400
Received: by pacyx8 with SMTP id yx8so27156684pac.2
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2015 22:42:50 -0700 (PDT)
From: Sunghoon Cho <ywhsbliss@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	chris.park@atmel.com, Rachel.kim@atmel.com, dean.lee@atmel.com
Cc: Sunghoon Cho <ywhsbliss@gmail.com>
Subject: [PATCH 1/5] staging: wilc1000: remove the warnings on the multiple blank lines.
Date: Wed, 17 Jun 2015 14:42:32 +0900
Message-Id: <99c95a41549a43582fd1c679c34723d54771cbcc.1434519635.git.ywhsbliss@gmail.com> (sfid-20150617_074301_788027_C78FB353)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the warnings reported by checkpatch.pl regarding on
the multiple blank line uses.

Signed-off-by: Sunghoon Cho <ywhsbliss@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 2331a00..a8b1501 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -35,16 +35,12 @@
 #include <linux/ip.h>          /* struct iphdr */
 #include <linux/tcp.h>         /* struct tcphdr */
 #include <linux/skbuff.h>
-
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>
-
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>
 #include <net/ieee80211_radiotap.h>
 #include <linux/if_arp.h>
-
-
 #include <linux/in6.h>
 #include <asm/checksum.h>
 #include "host_interface.h"
@@ -55,8 +51,6 @@
 #define FLOW_CONTROL_UPPER_THRESHOLD	256
 
 /*iftype*/
-
-
 enum stats_flags {
 	WILC_WFI_RX_PKT = 1 << 0,
 	WILC_WFI_TX_PKT = 1 << 1,
@@ -131,14 +125,11 @@ struct WILC_WFI_priv {
 	#ifdef WILC_P2P
 	struct wilc_wfi_p2pListenParams strRemainOnChanParams;
 	u64 u64tx_cookie;
-
 	#endif
 
 	bool bCfgScanning;
 	u32 u32RcvdChCount;
 
-
-
 	u8 au8AssociatedBss[ETH_ALEN];
 	struct sta_info assoc_stainfo;
 	struct net_device_stats stats;
@@ -180,7 +171,6 @@ typedef struct {
 
 } struct_frame_reg;
 
-
 #define NUM_CONCURRENT_IFC 2
 typedef struct {
 	uint8_t aSrcAddress[ETH_ALEN];
@@ -191,8 +181,6 @@ typedef struct {
 typedef struct {
 	int mac_status;
 	int wilc1000_initialized;
-
-
 	#if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
 	unsigned short dev_irq_num;
 	#endif
@@ -224,9 +212,6 @@ typedef struct {
 	struct task_struct *rx_bh_thread;
 	struct semaphore rx_sem;
 #endif
-
-
-
 	struct semaphore rxq_thread_started;
 	struct semaphore txq_thread_started;
 
-- 
1.9.1

