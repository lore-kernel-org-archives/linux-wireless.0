Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33705 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab2KSQQY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 11:16:24 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Fengguang Wu <fengguang.wu@intel.com>,
	Arend van Spriel <arend@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] brcmfmac: include linux/vmalloc.h from usb.c
Date: Mon, 19 Nov 2012 11:04:28 -0500
Message-Id: <1353341068-24532-1-git-send-email-linville@tuxdriver.com> (sfid-20121119_171627_856160_41C3176A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>

This avoids build failures on some architectures...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index feaca14..39a5baa 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/firmware.h>
 #include <linux/usb.h>
+#include <linux/vmalloc.h>
 
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
-- 
1.7.11.7

