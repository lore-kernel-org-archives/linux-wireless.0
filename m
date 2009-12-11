Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:61345 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757531AbZLKNl3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 08:41:29 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 12/31] wl1271: fix one typo in the rx_rssi_and_proc_compens values
Date: Fri, 11 Dec 2009 15:40:51 +0200
Message-Id: <1260538870-32297-13-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
References: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There was a typo in one of the values in the rx_rssi_and_proc_compens elemt
of the Radio Parameters struct.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 8c44f4c..147aab2 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -278,7 +278,7 @@ static struct conf_drv_settings default_conf = {
 			.tx_trace_loss       = 0x0,
 			.rx_rssi_and_proc_compens = {
 				0xec, 0xf6, 0x00, 0x0c, 0x18, 0xf8,
-				0xfc, 0x00, 0x08, 0x10, 0xf0, 0xf8,
+				0xfc, 0x00, 0x80, 0x10, 0xf0, 0xf8,
 				0x00, 0x0a, 0x14 },
 			.rx_trace_loss_5     = { 0, 0, 0, 0, 0, 0, 0 },
 			.tx_trace_loss_5     = { 0, 0, 0, 0, 0, 0, 0 },
-- 
1.6.3.3

