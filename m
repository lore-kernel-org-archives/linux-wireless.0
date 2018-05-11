Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:42663 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752751AbeEKIOz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 04:14:55 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 18/30] staging: wilc1000: fix line over 80 chars in wilc_create_wiphy() declaration
Date: Fri, 11 May 2018 13:43:19 +0530
Message-ID: <1526026411-11058-19-git-send-email-ajay.kathat@microchip.com> (sfid-20180511_101500_931840_40602E58)
In-Reply-To: <1526026411-11058-1-git-send-email-ajay.kathat@microchip.com>
References: <1526026411-11058-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix line over 80 characters issue found by checkpatch.pl script in
function declaration.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index c1a2421..a69103b 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -3,7 +3,8 @@
 #define NM_WFI_CFGOPERATIONS
 #include "wilc_wfi_netdevice.h"
 
-struct wireless_dev *wilc_create_wiphy(struct net_device *net, struct device *dev);
+struct wireless_dev *wilc_create_wiphy(struct net_device *net,
+				       struct device *dev);
 void wilc_free_wiphy(struct net_device *net);
 int wilc_deinit_host_int(struct net_device *net);
 int wilc_init_host_int(struct net_device *net);
-- 
2.7.4
