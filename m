Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:44536 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751515AbeCTQ41 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 12:56:27 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 10/11] staging: wilc1000: remove unused 'struct add_key_params'
Date: Tue, 20 Mar 2018 22:25:43 +0530
Message-ID: <1521564944-3565-11-git-send-email-ajay.kathat@microchip.com> (sfid-20180320_175631_463161_0D987A42)
In-Reply-To: <1521564944-3565-1-git-send-email-ajay.kathat@microchip.com>
References: <1521564944-3565-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove unused struct data structure.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index af1b8aa..b9bba86 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -160,12 +160,6 @@ static struct ieee80211_supported_band WILC_WFI_band_2ghz = {
 	.n_bitrates = ARRAY_SIZE(ieee80211_bitrates),
 };
 
-struct add_key_params {
-	u8 key_idx;
-	bool pairwise;
-	u8 *mac_addr;
-};
-
 #define AGING_TIME	(9 * 1000)
 #define during_ip_time	15000
 
-- 
2.7.4
