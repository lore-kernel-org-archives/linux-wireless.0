Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:49403 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754516AbeBPPMK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 10:12:10 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 04/12] staging: wilc1000: fix open parenthesis alignment mismatch in wilc_parse_network_info()
Date: Fri, 16 Feb 2018 20:41:41 +0530
Message-ID: <1518793909-15573-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180216_161216_235962_F25F0464)
In-Reply-To: <1518793909-15573-1-git-send-email-ajay.kathat@microchip.com>
References: <1518793909-15573-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Alignment should match open parenthesis" issue found by
checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index e98fc8e..2e2187b 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -320,8 +320,8 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
 		get_ssid(msa, network_info->ssid, &network_info->ssid_len);
 		get_BSSID(msa, network_info->bssid);
 
-		network_info->ch = get_current_channel_802_11n(msa,
-							rx_len + FCS_LEN);
+		network_info->ch = get_current_channel_802_11n(msa, rx_len
+							       + FCS_LEN);
 
 		index = MAC_HDR_LEN + TIME_STAMP_LEN;
 
-- 
2.7.4
