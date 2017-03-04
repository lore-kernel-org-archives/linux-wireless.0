Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34627 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752337AbdCDP6P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Mar 2017 10:58:15 -0500
From: Arushi Singhal <arushisinghal19971997@gmail.com>
To: w.d.hubbs@gmail.com
Cc: chris@the-brannons.com, outreachy-kernel@googlegroups.com,
        kirk@reisers.ca, samuel.thibault@ens-lyon.org,
        gregkh@linuxfoundation.org, speakup@linux-speakup.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        linux-wireless@vger.kernel.org,
        Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH 5/6] staging: wilc1000: function prototype argument should have identifier name
Date: Sat,  4 Mar 2017 21:27:39 +0530
Message-Id: <20170304155740.26105-6-arushisinghal19971997@gmail.com> (sfid-20170304_165949_110428_879D7E7A)
In-Reply-To: <20170304155740.26105-1-arushisinghal19971997@gmail.com>
References: <20170304155740.26105-1-arushisinghal19971997@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

function prototype argument should have an identifier name as reported
by checkpatch.pl.

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 drivers/staging/wilc1000/wilc_wlan.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 11365efcc5d0..7a5eba9b5f47 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -274,8 +274,8 @@ struct wilc_vif;
 
 int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer,
 				u32 buffer_size);
-int wilc_wlan_start(struct wilc *);
-int wilc_wlan_stop(struct wilc *);
+int wilc_wlan_start(struct wilc *wilc);
+int wilc_wlan_stop(struct wilc *wilc);
 int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			      u32 buffer_size, wilc_tx_complete_func_t func);
 int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count);
@@ -291,7 +291,7 @@ int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 void wilc_chip_sleep_manually(struct wilc *wilc);
 
 void wilc_enable_tcp_ack_filter(bool value);
-int wilc_wlan_get_num_conn_ifcs(struct wilc *);
+int wilc_wlan_get_num_conn_ifcs(struct wilc *wilc);
 int wilc_mac_xmit(struct sk_buff *skb, struct net_device *dev);
 
 void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size);
-- 
2.11.0
