Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41484 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739AbZHMTbt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 15:31:49 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Christian Lamparter <chunkeey@web.de>
Subject: [PATCH 04/20] wireless: move p54 and prism54 drivers closeer on kconfig
Date: Thu, 13 Aug 2009 15:31:33 -0400
Message-Id: <1250191909-21682-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
References: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: Christian Lamparter <chunkeey@web.de>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 1388176..996bc86 100644
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
@@ -515,8 +517,6 @@ source "drivers/net/wireless/ipw2x00/Kconfig"
 source "drivers/net/wireless/iwlwifi/Kconfig"
 source "drivers/net/wireless/iwmc3200wifi/Kconfig"
 endif # INTEL_80211
-
-source "drivers/net/wireless/p54/Kconfig"
 source "drivers/net/wireless/ath/Kconfig"
 source "drivers/net/wireless/hostap/Kconfig"
 source "drivers/net/wireless/b43/Kconfig"
-- 
1.6.2.5

