Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:63547 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762618AbZLKLlx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 06:41:53 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 12/31] wl1271: fix one typo in the rx_rssi_and_proc_compens values
Date: Fri, 11 Dec 2009 13:41:03 +0200
Message-Id: <1260531682-4695-13-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
References: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
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
index 9be9aff..d473d86 100644
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

