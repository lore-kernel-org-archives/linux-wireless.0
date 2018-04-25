Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:46871 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755853AbeDYRT7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 13:19:59 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 14/21] staging: wilc1000: rename num_reg_frame macro to have uppercase in macro name
Date: Wed, 25 Apr 2018 22:48:19 +0530
Message-ID: <1524676706-13179-15-git-send-email-ajay.kathat@microchip.com> (sfid-20180425_192004_493773_9725DF75)
In-Reply-To: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
References: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to follow name as per linux coding style.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 35bc4df..4bc1899 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -65,7 +65,7 @@ struct wilc_wfi_stats {
  * packets in and out, so there is place for a packet
  */
 
-#define num_reg_frame 2
+#define NUM_REG_FRAME 2
 
 struct wilc_wfi_key {
 	u8 *key;
@@ -146,7 +146,7 @@ struct wilc_vif {
 	u8 iftype;
 	int monitor_flag;
 	int mac_opened;
-	struct frame_reg frame_reg[num_reg_frame];
+	struct frame_reg frame_reg[NUM_REG_FRAME];
 	struct net_device_stats netstats;
 	struct wilc *wilc;
 	u8 src_addr[ETH_ALEN];
-- 
2.7.4
