Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:62472 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726625AbeGSGqe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 02:46:34 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 14/23] staging: wilc1000: remove unnecessary blank line between variable declaration
Date: Thu, 19 Jul 2018 04:15:10 +0530
Message-ID: <1531953919-20804-15-git-send-email-ajay.kathat@microchip.com> (sfid-20180719_080512_594580_65033ABC)
In-Reply-To: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
References: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove the unnecessary blank line between variables
declaration inside the function.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_mon.c              | 1 -
 drivers/staging/wilc1000/linux_wlan.c             | 1 -
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ----
 3 files changed, 6 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index bd09611..14405bf 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -147,7 +147,6 @@ static netdev_tx_t wilc_wfi_mon_xmit(struct sk_buff *skb,
 {
 	u32 rtap_len, ret = 0;
 	struct wilc_wfi_mon_priv  *mon_priv;
-
 	struct sk_buff *skb2;
 	struct wilc_wfi_radiotap_cb_hdr *cb_hdr;
 
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 84d3145..8f77435 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -780,7 +780,6 @@ static int mac_init_fn(struct net_device *ndev)
 static int wilc_mac_open(struct net_device *ndev)
 {
 	struct wilc_vif *vif;
-
 	unsigned char mac_add[ETH_ALEN] = {0};
 	int ret = 0;
 	int i = 0;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index ebe7adc2..43003d8 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1250,7 +1250,6 @@ static int del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 {
 	u32 i;
 	s32 ret = 0;
-
 	struct wilc_priv *priv = wiphy_priv(wiphy);
 
 	for (i = 0; i < priv->pmkid_list.numpmkid; i++)	{
@@ -1315,7 +1314,6 @@ static inline void wilc_wfi_cfg_parse_ch_attr(u8 *buf, u8 ch_list_attr_idx,
 static void wilc_wfi_cfg_parse_rx_action(u8 *buf, u32 len)
 {
 	u32 index = 0;
-
 	u8 op_channel_attr_index = 0;
 	u8 channel_list_attr_index = 0;
 
@@ -1338,7 +1336,6 @@ static void wilc_wfi_cfg_parse_tx_action(u8 *buf, u32 len, bool oper_ch,
 					 u8 iftype)
 {
 	u32 index = 0;
-
 	u8 op_channel_attr_index = 0;
 	u8 channel_list_attr_index = 0;
 
@@ -2261,7 +2258,6 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net,
 int wilc_init_host_int(struct net_device *net)
 {
 	int ret = 0;
-
 	struct wilc_priv *priv;
 
 	priv = wdev_priv(net->ieee80211_ptr);
-- 
2.7.4
