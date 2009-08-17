Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53098 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757615AbZHQR1b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 13:27:31 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Christian Lamparter <chunkeey@web.de>
Subject: [PATCH v5 05/33] wireless: move p54 and prism54 drivers closer on kconfig
Date: Mon, 17 Aug 2009 13:27:04 -0400
Message-Id: <1250530052-14783-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
References: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: Christian Lamparter <chunkeey@web.de>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index fdf0257..cfd192e 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -284,6 +284,8 @@ config PCMCIA_WL3501
 	 It has basic support for Linux wireless extensions and initial
 	 micro support for ethtool.
 
+source "drivers/net/wireless/p54/Kconfig"
+
 config PRISM54
 	tristate 'Intersil Prism GT/Duette/Indigo PCI/Cardbus' 
 	depends on PCI && EXPERIMENTAL && WLAN_80211
@@ -503,7 +505,6 @@ config MAC80211_HWSIM
 	  To compile this driver as a module, choose M here: the module will be
 	  called mac80211_hwsim.  If unsure, say N.
 
-source "drivers/net/wireless/p54/Kconfig"
 source "drivers/net/wireless/ath/Kconfig"
 
 menuconfig INTEL_80211
-- 
1.6.2.5

