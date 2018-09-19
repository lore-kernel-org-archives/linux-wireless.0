Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:2391 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731022AbeISLn3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 07:43:29 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 28/29] staging: wilc1000: avoid spaces preferred around checkpatch issue
Date: Wed, 19 Sep 2018 11:35:18 +0530
Message-ID: <1537337119-14952-29-git-send-email-ajay.kathat@microchip.com> (sfid-20180919_080710_997001_1E47A494)
In-Reply-To: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
References: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to add extra spaces around the '/' to avoid the below
checkpatch warning.

'spaces preferred around that '/' (ctx:VxV)'

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 695d5b2..29c1317 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -823,7 +823,7 @@ static void wilc_set_multicast_list(struct net_device *dev)
 
 	netdev_for_each_mc_addr(ha, dev) {
 		memcpy(mc_list + i, ha->addr, ETH_ALEN);
-		netdev_dbg(dev, "Entry[%d]: %x:%x:%x:%x:%x:%x\n", i/ETH_ALEN,
+		netdev_dbg(dev, "Entry[%d]: %x:%x:%x:%x:%x:%x\n", i / ETH_ALEN,
 			   mc_list[i], mc_list[i + 1], mc_list[i + 2],
 			   mc_list[i + 3], mc_list[i + 4], mc_list[i + 5]);
 		i += ETH_ALEN;
-- 
2.7.4
