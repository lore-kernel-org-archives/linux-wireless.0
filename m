Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45314 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521AbZHNAnE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 20:43:04 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH v2 22/25] wireless: remove "Wireless" from rndis kconfig entry
Date: Thu, 13 Aug 2009 20:43:01 -0400
Message-Id: <1250210584-13374-23-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250210584-13374-1-git-send-email-lrodriguez@atheros.com>
References: <1250210584-13374-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 6239d5f..e441b66 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -558,7 +558,7 @@ config PCMCIA_WL3501
 	 micro support for ethtool.
 
 config USB_NET_RNDIS_WLAN
-	tristate "Wireless RNDIS USB support"
+	tristate "RNDIS USB support"
 	depends on USB && EXPERIMENTAL
 	depends on CFG80211
 	select USB_USBNET
-- 
1.6.2.5

