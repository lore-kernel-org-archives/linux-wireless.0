Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:33698 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731001AbeISLmi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 07:42:38 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 14/29] staging: wilc1000: remove unused wid type values
Date: Wed, 19 Sep 2018 11:35:04 +0530
Message-ID: <1537337119-14952-15-git-send-email-ajay.kathat@microchip.com> (sfid-20180919_080630_262344_2F42DF15)
In-Reply-To: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
References: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove the wid type not used in the code.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan_if.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index b81a73b..ce2066b 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -204,10 +204,6 @@ enum wid_type {
 	WID_STR			= 3,
 	WID_BIN_DATA		= 4,
 	WID_BIN			= 5,
-	WID_IP			= 6,
-	WID_ADR			= 7,
-	WID_UNDEF		= 8,
-	WID_TYPE_FORCE_32BIT	= 0xFFFFFFFF
 };
 
 struct wid {
-- 
2.7.4
