Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:54330 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753328AbeDRLlM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 07:41:12 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 22/22] staging: wilc1000: rename pu32InactiveTime to avoid camelCase issue
Date: Wed, 18 Apr 2018 17:09:24 +0530
Message-ID: <1524051564-15497-23-git-send-email-ajay.kathat@microchip.com> (sfid-20180418_134115_395488_2CF6874E)
In-Reply-To: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com>
References: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoid camelCase issues found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 035c537..7a26f34 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -314,7 +314,7 @@ int wilc_add_ptk(struct wilc_vif *vif, const u8 *ptk, u8 ptk_key_len,
 		 const u8 *mac_addr, const u8 *rx_mic, const u8 *tx_mic,
 		 u8 mode, u8 cipher_mode, u8 index);
 s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
-			   u32 *pu32InactiveTime);
+			   u32 *out_val);
 int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 		    u8 index, u32 key_rsc_len, const u8 *key_rsc,
 		    const u8 *rx_mic, const u8 *tx_mic, u8 mode,
-- 
2.7.4
