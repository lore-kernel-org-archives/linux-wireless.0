Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:43606 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751884AbeAPODD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 09:03:03 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 04/13] staging: wilc1000: remove unused element in wilc_wfi_p2p_listen_params struct
Date: Tue, 16 Jan 2018 19:32:22 +0530
Message-ID: <1516111351-5353-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180116_150403_900823_43448CA9)
In-Reply-To: <1516111351-5353-1-git-send-email-ajay.kathat@microchip.com>
References: <1516111351-5353-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is cleanup patch, to remove the unused "tenuChannelType" element
from wilc_wfi_p2p_listen_params structure.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index a4c193e..3337fb2 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -92,7 +92,6 @@ struct sta_info {
 /*Parameters needed for host interface for  remaining on channel*/
 struct wilc_wfi_p2p_listen_params {
 	struct ieee80211_channel *listen_ch;
-	enum nl80211_channel_type tenuChannelType;
 	u32 listen_duration;
 	u64 listen_cookie;
 	u32 listen_session_id;
-- 
2.7.4
