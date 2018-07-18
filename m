Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:30616 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729891AbeGSGqH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 02:46:07 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 06/23] staging: wilc1000: rename enum CURRENT_TXRATE to use lowercase
Date: Thu, 19 Jul 2018 04:15:02 +0530
Message-ID: <1531953919-20804-7-git-send-email-ajay.kathat@microchip.com> (sfid-20180719_080458_830703_B7EB057B)
In-Reply-To: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
References: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to rename enums in lowercase to follow linux coding style.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 drivers/staging/wilc1000/host_interface.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 7309b7e..cc64b14 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -695,7 +695,7 @@ static void handle_cfg_param(struct work_struct *work)
 		i++;
 	}
 	if (param->flag & CURRENT_TX_RATE) {
-		enum CURRENT_TXRATE curr_tx_rate = param->curr_tx_rate;
+		enum current_tx_rate curr_tx_rate = param->curr_tx_rate;
 
 		if (curr_tx_rate == AUTORATE || curr_tx_rate == MBPS_1 ||
 		    curr_tx_rate == MBPS_2 || curr_tx_rate == MBPS_5_5 ||
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 3cd97dd..64fc269 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -81,7 +81,7 @@ struct host_if_pmkid_attr {
 	struct host_if_pmkid pmkidlist[WILC_MAX_NUM_PMKIDS];
 };
 
-enum CURRENT_TXRATE {
+enum current_tx_rate {
 	AUTORATE	= 0,
 	MBPS_1		= 1,
 	MBPS_2		= 2,
@@ -118,7 +118,7 @@ struct cfg_param_attr {
 	u8 scan_source;
 	u16 active_scan_time;
 	u16 passive_scan_time;
-	enum CURRENT_TXRATE curr_tx_rate;
+	enum current_tx_rate curr_tx_rate;
 
 };
 
-- 
2.7.4
