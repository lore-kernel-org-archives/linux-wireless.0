Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:61379 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466AbZLKNlm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 08:41:42 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH v2 17/31] wl1271: Configure smart-reflex paramter values.
Date: Fri, 11 Dec 2009 15:40:56 +0200
Message-Id: <1260538870-32297-18-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
References: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Configure correct values to be used with the smart-reflex configuration of the
firmware.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 55a45d3..b0f4c6e 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -260,12 +260,12 @@ static struct conf_drv_settings default_conf = {
 			.tx_bip_fem_manufacturer = 1,
 			.settings = 1,
 			.sr_state = 1,
-			.srf1 = { 0, 0, 0, 0, 0, 0, 0, 0,
-				  0, 0, 0, 0, 0, 0, 0, 0 },
-			.srf2 = { 0, 0, 0, 0, 0, 0, 0, 0,
-				  0, 0, 0, 0, 0, 0, 0, 0 },
-			.srf3 = { 0, 0, 0, 0, 0, 0, 0, 0,
-				  0, 0, 0, 0, 0, 0, 0, 0 },
+			.srf1 = { 0x07, 0x03, 0x18, 0x10, 0x05, 0xfb, 0xf0,
+				  0xe8, 0, 0, 0, 0, 0, 0, 0, 0 },
+			.srf2 = { 0x07, 0x03, 0x18, 0x10, 0x05, 0xfb, 0xf0,
+				  0xe8, 0, 0, 0, 0, 0, 0, 0, 0 },
+			.srf3 = { 0x07, 0x03, 0x18, 0x10, 0x05, 0xfb, 0xf0,
+				  0xe8, 0, 0, 0, 0, 0, 0, 0, 0 },
 			.sr_debug_table = { 0, 0, 0, 0, 0, 0, 0, 0,
 					    0, 0, 0, 0, 0, 0, 0, 0 },
 			.sr_sen_n_p = 0,
-- 
1.6.3.3

