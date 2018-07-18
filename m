Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:22969 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726625AbeGSGqY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 02:46:24 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 11/23] staging: wilc1000: removed unused element from wilc_cfg_frame struct
Date: Thu, 19 Jul 2018 04:15:07 +0530
Message-ID: <1531953919-20804-12-git-send-email-ajay.kathat@microchip.com> (sfid-20180719_080501_771557_099CC6CC)
In-Reply-To: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
References: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup up patch to remove the unused structure elements in
'wilc_cfg_frame' struct.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index dbdebf0..f29d1ea 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -255,9 +255,6 @@ struct wilc_hif_func {
 #define MAX_CFG_FRAME_SIZE	1468
 
 struct wilc_cfg_frame {
-	u8 ether_header[14];
-	u8 ip_header[20];
-	u8 udp_header[8];
 	u8 wid_header[8];
 	u8 frame[MAX_CFG_FRAME_SIZE];
 };
-- 
2.7.4
