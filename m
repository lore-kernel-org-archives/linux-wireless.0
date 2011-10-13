Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53269 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab1JMOZ6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Oct 2011 10:25:58 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: arend@broadcom.com, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] brcm80211: rename CONFIG_BRCMUMAC to CONFIG_BRCMUTIL
Date: Thu, 13 Oct 2011 16:25:49 +0200
Message-Id: <1318515949-9558-1-git-send-email-hauke@hauke-m.de> (sfid-20111013_162620_528734_10EF53D2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no config option named CONFIG_BRCMUMAC this should be
CONFIG_BRCMUTIL as this is missing here.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 0a304b0..812a050 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -59,5 +59,5 @@ obj-$(CONFIG_IWM)	+= iwmc3200wifi/
 
 obj-$(CONFIG_MWIFIEX)	+= mwifiex/
 obj-$(CONFIG_BRCMFMAC) += brcm80211/
-obj-$(CONFIG_BRCMUMAC) += brcm80211/
+obj-$(CONFIG_BRCMUTIL) += brcm80211/
 obj-$(CONFIG_BRCMSMAC) += brcm80211/
-- 
1.7.4.1

