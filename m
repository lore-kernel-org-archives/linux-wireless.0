Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:12456 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731240AbeITMHV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 08:07:21 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 28/29] staging: wilc1000: avoid spaces preferred around checkpatch issue
Date: Thu, 20 Sep 2018 11:53:39 +0530
Message-ID: <1537424620-6982-29-git-send-email-ajay.kathat@microchip.com> (sfid-20180920_082630_755362_68FC93B9)
In-Reply-To: <1537424620-6982-1-git-send-email-ajay.kathat@microchip.com>
References: <1537424620-6982-1-git-send-email-ajay.kathat@microchip.com>
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
