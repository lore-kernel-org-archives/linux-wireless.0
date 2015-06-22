Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:35254 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbbFVEIj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 00:08:39 -0400
Received: by pdbci14 with SMTP id ci14so71268095pdb.2
        for <linux-wireless@vger.kernel.org>; Sun, 21 Jun 2015 21:08:38 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 4/5] staging: wilc1000: wilc_wfi_netdevice.c: Insert blank line after declarations
Date: Mon, 22 Jun 2015 13:08:14 +0900
Message-Id: <1434946095-26157-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20150622_060850_066648_45E7D660)
In-Reply-To: <1434946095-26157-1-git-send-email-chaehyun.lim@gmail.com>
References: <1434946095-26157-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix checkpatch warning found by checkpatch.pl
WARNING: Missing a blank line after declarations

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.c b/drivers/staging/wilc1000/wilc_wfi_netdevice.c
index 039e21f..31a796b 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.c
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.c
@@ -207,6 +207,7 @@ struct WILC_WFI_packet *WILC_WFI_DequeueBuf(struct net_device *dev)
 static void WILC_WFI_RxInts(struct net_device *dev, int enable)
 {
 	struct WILC_WFI_priv *priv = netdev_priv(dev);
+
 	priv->rx_int_enabled = enable;
 }
 
@@ -522,6 +523,7 @@ void WILC_WFI_HwTx(char *buf, int len, struct net_device *dev)
 
 	if (0) {  /* enable this conditional to look at the data */
 		int i;
+
 		PRINT_D(RX_DBG, "len is %i", len);
 		for (i = 14; i < len; i++)
 			PRINT_D(RX_DBG, "TXdata[%d] %02x\n", i, buf[i] & 0xff);
@@ -677,6 +679,7 @@ int WILC_WFI_Ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 struct net_device_stats *WILC_WFI_Stats(struct net_device *dev)
 {
 	struct WILC_WFI_priv *priv = netdev_priv(dev);
+
 	return &priv->stats;
 }
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
