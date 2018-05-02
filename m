Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:53183 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751339AbeEBHPu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 03:15:50 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 18/21] staging: wilc1000: move macro after the #include file in wilc_wfi_netdevice
Date: Wed, 2 May 2018 12:43:44 +0530
Message-ID: <1525245227-3924-19-git-send-email-ajay.kathat@microchip.com> (sfid-20180502_093236_316847_4D028212)
In-Reply-To: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
References: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to organize macro in a file together after #include
statements.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 01cb9ac..8849924 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -2,11 +2,6 @@
 #ifndef WILC_WFI_NETDEVICE
 #define WILC_WFI_NETDEVICE
 
-#define WILC_MAX_NUM_PMKIDS  16
-#define PMKID_LEN  16
-#define PMKID_FOUND 1
- #define NUM_STA_ASSOCIATED 8
-
 #include <linux/tcp.h>
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>
@@ -16,8 +11,15 @@
 #include "host_interface.h"
 #include "wilc_wlan.h"
 
-#define FLOW_CONTROL_LOWER_THRESHOLD	128
-#define FLOW_CONTROL_UPPER_THRESHOLD	256
+#define FLOW_CONTROL_LOWER_THRESHOLD		128
+#define FLOW_CONTROL_UPPER_THRESHOLD		256
+
+#define WILC_MAX_NUM_PMKIDS			16
+#define PMKID_LEN				16
+#define PMKID_FOUND				1
+#define NUM_STA_ASSOCIATED			8
+
+#define NUM_REG_FRAME				2
 
 struct wilc_wfi_stats {
 	unsigned long rx_packets;
@@ -34,8 +36,6 @@ struct wilc_wfi_stats {
  * packets in and out, so there is place for a packet
  */
 
-#define NUM_REG_FRAME 2
-
 struct wilc_wfi_key {
 	u8 *key;
 	u8 *seq;
-- 
2.7.4
