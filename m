Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:39174 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758706AbZFLLSH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:18:07 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 30/33] wl12xx: remove unused wl12xx_hw_init_mem_config()
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:17:33 +0300
Message-ID: <20090612111733.8877.63876.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

The function declaration is a leftover from some earlier, already
removed, code.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Vidhya Govindan <vidhya.govindan@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_init.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_init.h b/drivers/net/wireless/wl12xx/wl1251_init.h
index 5b3301a..2b6268e 100644
--- a/drivers/net/wireless/wl12xx/wl1251_init.h
+++ b/drivers/net/wireless/wl12xx/wl1251_init.h
@@ -28,7 +28,6 @@
 
 int wl12xx_hw_init_hwenc_config(struct wl12xx *wl);
 int wl12xx_hw_init_templates_config(struct wl12xx *wl);
-int wl12xx_hw_init_mem_config(struct wl12xx *wl);
 int wl12xx_hw_init_rx_config(struct wl12xx *wl, u32 config, u32 filter);
 int wl12xx_hw_init_phy_config(struct wl12xx *wl);
 int wl12xx_hw_init_beacon_filter(struct wl12xx *wl);

