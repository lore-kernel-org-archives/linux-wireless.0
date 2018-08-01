Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:14807 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730915AbeHAMyI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Aug 2018 08:54:08 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 1/2] staging: wilc1000: use 'u16' data type for config id parameter
Date: Wed, 1 Aug 2018 16:40:59 +0530
Message-ID: <1533121860-20820-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180801_130855_666395_020E9423)
In-Reply-To: <1533121860-20820-1-git-send-email-ajay.kathat@microchip.com>
References: <1533121860-20820-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to use the correct data type 'u16' for keeping the WID
value in 'wilc_cfg_word' & 'wilc_cfg_str' structure.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan_cfg.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.h b/drivers/staging/wilc1000/wilc_wlan_cfg.h
index 08092a5..2aa7a9b 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.h
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.h
@@ -22,12 +22,12 @@ struct wilc_cfg_hword {
 };
 
 struct wilc_cfg_word {
-	u32 id;
+	u16 id;
 	u32 val;
 };
 
 struct wilc_cfg_str {
-	u32 id;
+	u16 id;
 	u8 *str;
 };
 
-- 
2.7.4
