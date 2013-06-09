Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50351 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909Ab3FILKU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jun 2013 07:10:20 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: qca_vkondrat@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] wil6210: fix name of tracing config option
Date: Sun,  9 Jun 2013 13:10:05 +0200
Message-Id: <1370776205-3755-1-git-send-email-hauke@hauke-m.de> (sfid-20130609_131024_140705_37F48F1C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tracing in wil6210 is activated with WIL6210_TRACING and not with
ATH6KL_TRACING, this is used for the ath6kl driver. Rename the config
option.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/ath/wil6210/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/Kconfig b/drivers/net/wireless/ath/wil6210/Kconfig
index 5644ac5..ce8c038 100644
--- a/drivers/net/wireless/ath/wil6210/Kconfig
+++ b/drivers/net/wireless/ath/wil6210/Kconfig
@@ -28,7 +28,7 @@ config WIL6210_ISR_COR
 	  such monitoring impossible.
 	  Say y unless you debug interrupts
 
-config ATH6KL_TRACING
+config WIL6210_TRACING
 	bool "wil6210 tracing support"
 	depends on WIL6210
 	depends on EVENT_TRACING
-- 
1.7.10.4

