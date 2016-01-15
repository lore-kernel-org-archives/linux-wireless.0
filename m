Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52487 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756069AbcARSBz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jan 2016 13:01:55 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH] brcmfmac: add missing include
Date: Fri, 15 Jan 2016 16:00:30 +0100
Message-Id: <1452870030-56506-1-git-send-email-nbd@openwrt.org> (sfid-20160118_190158_609772_EB74F2CF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

linux/module.h is required for defining module parameters

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 4265b50..cfee477 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/netdevice.h>
+#include <linux/module.h>
 #include <brcmu_wifi.h>
 #include <brcmu_utils.h>
 #include "core.h"
-- 
2.2.2

