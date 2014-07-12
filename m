Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:46827 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbaGLM5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 08:57:42 -0400
Received: by mail-wg0-f49.google.com with SMTP id k14so1539164wgh.32
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jul 2014 05:57:41 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Daniel Drake <dsd@laptop.org>,
	Ulrich Kunitz <kune@deine-taler.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 1/1] wireless: zd1211rw: new url for fw, remove experimental
Date: Sat, 12 Jul 2014 14:57:38 +0200
Message-Id: <1405169858-6376-1-git-send-email-xose.vazquez@gmail.com> (sfid-20140712_145804_939662_9697A38C)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: Daniel Drake <dsd@laptop.org>
Cc: Ulrich Kunitz <kune@deine-taler.de>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/net/wireless/zd1211rw/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/Kconfig b/drivers/net/wireless/zd1211rw/Kconfig
index 96c8e1d..95920581 100644
--- a/drivers/net/wireless/zd1211rw/Kconfig
+++ b/drivers/net/wireless/zd1211rw/Kconfig
@@ -3,11 +3,11 @@ config ZD1211RW
 	depends on USB && MAC80211
 	select FW_LOADER
 	---help---
-	  This is an experimental driver for the ZyDAS ZD1211/ZD1211B wireless
+	  This is a driver for the ZyDAS ZD1211/ZD1211B wireless
 	  chip, present in many USB-wireless adapters.
 
 	  Device firmware is required alongside this driver. You can download
-	  the firmware distribution from http://zd1211.ath.cx/get-firmware
+	  the firmware distribution from http://sf.net/projects/zd1211/files/
 
 config ZD1211RW_DEBUG
 	bool "ZyDAS ZD1211 debugging"
-- 
1.9.3

