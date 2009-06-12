Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:39161 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbZFLLR7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:17:59 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 32/33] wl1251: fix a checkpatch warning
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:17:47 +0300
Message-ID: <20090612111747.8877.54789.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

drivers/net/wireless/wl12xx/wl1251_main.c:158: WARNING:
braces {} are not necessary for single statement blocks

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index f4bc579..11e1903 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -155,9 +155,8 @@ static void wl1251_fw_wakeup(struct wl1251 *wl)
 	wl1251_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, elp_reg);
 	elp_reg = wl1251_read32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR);
 
-	if (!(elp_reg & ELPCTRL_WLAN_READY)) {
+	if (!(elp_reg & ELPCTRL_WLAN_READY))
 		wl1251_warning("WLAN not ready");
-	}
 }
 
 static int wl1251_chip_wakeup(struct wl1251 *wl)

