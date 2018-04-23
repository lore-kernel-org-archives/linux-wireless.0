Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:16615 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932110AbeDWQfx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 12:35:53 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [RESEND 23/33] staging: wilc1000: remove multiple define used for MAX_SSID_LEN
Date: Mon, 23 Apr 2018 22:03:25 +0530
Message-ID: <1524501215-4963-24-git-send-email-ajay.kathat@microchip.com> (sfid-20180423_183619_889931_C380206E)
In-Reply-To: <1524501215-4963-1-git-send-email-ajay.kathat@microchip.com>
References: <1524501215-4963-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to have commonly used macro in common header file to avoid
same defination in mulitple file. Removed MAX_SSID_LEN macro from
coreconfigurator.h header as its already defined in wilc_wlan_if.h.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/staging/wilc1000/coreconfigurator.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 5436fd3..1666b7a 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -17,7 +17,6 @@
 #define NUM_RSSI                5
 
 #define MAC_HDR_LEN             24
-#define MAX_SSID_LEN            33
 #define FCS_LEN                 4
 #define TIME_STAMP_LEN          8
 #define BEACON_INTERVAL_LEN     2
-- 
2.7.4
