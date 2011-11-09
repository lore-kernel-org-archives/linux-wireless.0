Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54966 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab1KIUaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 15:30:14 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend@broadcom.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless: cleanup brcm80211 bits in drivers/net/wireless/Makefile
Date: Wed,  9 Nov 2011 15:27:05 -0500
Message-Id: <1320870425-21200-1-git-send-email-linville@tuxdriver.com> (sfid-20111109_213019_796226_789A6C7F)
In-Reply-To: <1318515949-9558-1-git-send-email-hauke@hauke-m.de>
References: <1318515949-9558-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 0a304b0..c1c0678 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -58,6 +58,6 @@ obj-$(CONFIG_WL12XX_PLATFORM_DATA)	+= wl12xx/
 obj-$(CONFIG_IWM)	+= iwmc3200wifi/
 
 obj-$(CONFIG_MWIFIEX)	+= mwifiex/
-obj-$(CONFIG_BRCMFMAC) += brcm80211/
-obj-$(CONFIG_BRCMUMAC) += brcm80211/
-obj-$(CONFIG_BRCMSMAC) += brcm80211/
+
+obj-$(CONFIG_BRCMFMAC)	+= brcm80211/
+obj-$(CONFIG_BRCMSMAC)	+= brcm80211/
-- 
1.7.4.4

