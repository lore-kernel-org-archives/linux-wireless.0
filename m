Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:55566
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751702AbaI0VAZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Sep 2014 17:00:25 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH] ath5k: add missing include for debug code
Date: Sat, 27 Sep 2014 18:05:47 +0200
Message-Id: <1411833947-56000-1-git-send-email-nbd@openwrt.org> (sfid-20140927_230028_752732_B49B2FB8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Needed for calling vmalloc()/vfree()

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath5k/debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 30e4e1f..bc99675 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -65,6 +65,7 @@
 
 #include <linux/seq_file.h>
 #include <linux/list.h>
+#include <linux/vmalloc.h>
 #include "debug.h"
 #include "ath5k.h"
 #include "reg.h"
-- 
2.0.4

