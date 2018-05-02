Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:63761 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751214AbeEBHPZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 03:15:25 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 10/21] staging: wilc1000: rename WILC_WFI_mon_xmit to avoid uppercase for function name
Date: Wed, 2 May 2018 12:43:36 +0530
Message-ID: <1525245227-3924-11-git-send-email-ajay.kathat@microchip.com> (sfid-20180502_093238_194735_6FA52A29)
In-Reply-To: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
References: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes to avoid the use of uppercase for function name.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_mon.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 1667646..d5af736 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -145,7 +145,7 @@ static int mon_mgmt_tx(struct net_device *dev, const u8 *buf, size_t len)
 	return 0;
 }
 
-static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
+static netdev_tx_t wilc_wfi_mon_xmit(struct sk_buff *skb,
 				     struct net_device *dev)
 {
 	u32 rtap_len, ret = 0;
@@ -218,7 +218,7 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 }
 
 static const struct net_device_ops wilc_wfi_netdev_ops = {
-	.ndo_start_xmit         = WILC_WFI_mon_xmit,
+	.ndo_start_xmit         = wilc_wfi_mon_xmit,
 
 };
 
-- 
2.7.4
