Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:17863 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754583AbeBPPMU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 10:12:20 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 07/12] staging: wilc1000: fix line over 80 chars in wilc_wlan_cfg_indicate_rxi()
Date: Fri, 16 Feb 2018 20:41:44 +0530
Message-ID: <1518793909-15573-8-git-send-email-ajay.kathat@microchip.com> (sfid-20180216_161224_019008_975B3AEC)
In-Reply-To: <1518793909-15573-1-git-send-email-ajay.kathat@microchip.com>
References: <1518793909-15573-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to fix "line over 80 characters" issue reported by
checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 752b292..ab69bac 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -523,9 +523,12 @@ int wilc_wlan_cfg_indicate_rx(struct wilc *wilc, u8 *frame, int size,
 	frame += 4;
 	size -= 4;
 
-	/**
-	 *      The  valid types of response messages are 'R' (Response), 'I' (Information), and 'N' (Network Information)
-	 **/
+	/*
+	 * The valid types of response messages are
+	 * 'R' (Response),
+	 * 'I' (Information), and
+	 * 'N' (Network Information)
+	 */
 
 	switch (msg_type) {
 	case 'R':
-- 
2.7.4
