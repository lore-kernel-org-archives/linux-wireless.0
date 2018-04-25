Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:42205 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754880AbeDYRT5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 13:19:57 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 13/21] staging: wilc1000: rename WILC_WFI_stats to avoid uppercase
Date: Wed, 25 Apr 2018 22:48:18 +0530
Message-ID: <1524676706-13179-14-git-send-email-ajay.kathat@microchip.com> (sfid-20180425_192002_946960_40C3E972)
In-Reply-To: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
References: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to have struct name as per linux coding style.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 07167637..35bc4df 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -50,7 +50,7 @@ enum stats_flags {
 	WILC_WFI_TX_PKT = BIT(1),
 };
 
-struct WILC_WFI_stats {
+struct wilc_wfi_stats {
 	unsigned long rx_packets;
 	unsigned long tx_packets;
 	unsigned long rx_bytes;
@@ -119,7 +119,7 @@ struct wilc_priv {
 	struct napi_struct napi;
 	struct host_if_drv *hif_drv;
 	struct host_if_pmkid_attr pmkid_list;
-	struct WILC_WFI_stats netstats;
+	struct wilc_wfi_stats netstats;
 	u8 wep_key[4][WLAN_KEY_LEN_WEP104];
 	u8 wep_key_len[4];
 	/* The real interface that the monitor is on */
-- 
2.7.4
