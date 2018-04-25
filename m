Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:58440 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754880AbeDYRTv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 13:19:51 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 11/21] staging: wilc1000: remove unused #define related to MAC status
Date: Wed, 25 Apr 2018 22:48:16 +0530
Message-ID: <1524676706-13179-12-git-send-email-ajay.kathat@microchip.com> (sfid-20180425_191957_038826_93398D1A)
In-Reply-To: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
References: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove below #define which are not used in code:

WILC_MAC_STATUS_READY
WILC_MAC_STATUS_CONNECT

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan_if.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index e8a56f4..1982348 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -49,8 +49,6 @@ struct sdio_cmd53 {
 
 #define WILC_MAC_INDICATE_STATUS	0x1
 #define WILC_MAC_STATUS_INIT		-1
-#define WILC_MAC_STATUS_READY		0
-#define WILC_MAC_STATUS_CONNECT		1
 
 #define WILC_MAC_INDICATE_SCAN		0x2
 
-- 
2.7.4
