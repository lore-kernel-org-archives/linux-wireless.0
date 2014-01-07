Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59073 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaAGMMW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 07:12:22 -0500
Date: Tue, 7 Jan 2014 13:12:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH v3 12/13] wl1251: add nvs file name to module firmware list
Message-ID: <20140107121220.GL10836@amd.pavel.ucw.cz> (sfid-20140107_131224_773460_2981E966)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add nvs file name to module firmware list

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/net/wireless/ti/wl1251/main.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 1ef264c..382dedf 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -1711,3 +1711,4 @@ MODULE_DESCRIPTION("TI wl1251 Wireles LAN Driver Core");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Kalle Valo <kvalo@adurom.com>");
 MODULE_FIRMWARE(WL1251_FW_NAME);
+MODULE_FIRMWARE(WL1251_NVS_NAME);
