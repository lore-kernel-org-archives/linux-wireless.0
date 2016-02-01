Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36307 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbcBAM1D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 07:27:03 -0500
Received: by mail-pf0-f196.google.com with SMTP id n128so7472135pfn.3
        for <linux-wireless@vger.kernel.org>; Mon, 01 Feb 2016 04:27:03 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 02/11] staging: wilc1000: linux_mon: remove blank lines after open brace '{'
Date: Mon,  1 Feb 2016 21:26:38 +0900
Message-Id: <1454329607-9486-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20160201_132707_780575_73AAB4FF)
In-Reply-To: <1454329607-9486-1-git-send-email-chaehyun.lim@gmail.com>
References: <1454329607-9486-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch remove blank lines after open brace found by checkpatch.pl
CHECK: Blank lines aren't necessary after an open brace '{'

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/linux_mon.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 284dfb0..73c8113 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -71,7 +71,6 @@ void WILC_WFI_monitor_rx(u8 *buff, u32 size)
 	pkt_offset = GET_PKT_OFFSET(header);
 
 	if (pkt_offset & IS_MANAGMEMENT_CALLBACK) {
-
 		/* hostapd callback mgmt frame */
 
 		skb = dev_alloc_skb(size + sizeof(struct wilc_wfi_radiotap_cb_hdr));
@@ -103,7 +102,6 @@ void WILC_WFI_monitor_rx(u8 *buff, u32 size)
 		}
 
 	} else {
-
 		skb = dev_alloc_skb(size + sizeof(struct wilc_wfi_radiotap_hdr));
 
 		if (skb == NULL) {
@@ -145,7 +143,6 @@ struct tx_complete_mon_data {
 
 static void mgmt_tx_complete(void *priv, int status)
 {
-
 	struct tx_complete_mon_data *pv_data = (struct tx_complete_mon_data *)priv;
 	u8 *buf =  pv_data->buff;
 
@@ -316,8 +313,6 @@ static const struct net_device_ops wilc_wfi_netdev_ops = {
  */
 struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_device *real_dev)
 {
-
-
 	u32 ret = 0;
 	struct WILC_WFI_mon_priv *priv;
 
-- 
2.7.0

