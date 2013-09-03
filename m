Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:60280 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723Ab3ICOe1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 10:34:27 -0400
Received: by mail-we0-f175.google.com with SMTP id m46so4998218wev.34
        for <linux-wireless@vger.kernel.org>; Tue, 03 Sep 2013 07:34:24 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 05/12] wl18xx: increase the number of allowed BA sessions
Date: Tue,  3 Sep 2013 17:34:01 +0300
Message-Id: <1378218848-7853-5-git-send-email-eliad@wizery.com> (sfid-20130903_163434_350503_FF6F4F55)
In-Reply-To: <1378218848-7853-1-git-send-email-eliad@wizery.com>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Victor Goldenshtein <victorg@ti.com>

The current fw (actually starting from fw 8.5.0.0.58)
supports 8 rx BA sessions.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/wl18xx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl18xx/wl18xx.h b/drivers/net/wireless/ti/wl18xx/wl18xx.h
index 9204e07..f700c4de 100644
--- a/drivers/net/wireless/ti/wl18xx/wl18xx.h
+++ b/drivers/net/wireless/ti/wl18xx/wl18xx.h
@@ -40,7 +40,7 @@
 
 #define WL18XX_NUM_MAC_ADDRESSES 3
 
-#define WL18XX_RX_BA_MAX_SESSIONS 5
+#define WL18XX_RX_BA_MAX_SESSIONS 8
 
 struct wl18xx_priv {
 	/* buffer for sending commands to FW */
-- 
1.8.3.rc1.35.g9b79519

