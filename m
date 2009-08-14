Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45288 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583AbZHNAnE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 20:43:04 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Daniel Drake <dsd@gentoo.org>,
	Stephen Chen <stephen.chen@atheros.com>
Subject: [PATCH v2 07/25] wireless: move zd1211rw option closer to old ZyDAS on kconfig
Date: Thu, 13 Aug 2009 20:42:46 -0400
Message-Id: <1250210584-13374-8-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250210584-13374-1-git-send-email-lrodriguez@atheros.com>
References: <1250210584-13374-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: Daniel Drake <dsd@gentoo.org>
Cc: Stephen Chen <stephen.chen@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index babd36e..5593342 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -347,6 +347,8 @@ config PRISM54
 
 endif # CONEXANT_ST_80211
 
+source "drivers/net/wireless/zd1211rw/Kconfig"
+
 config USB_ZD1201
 	tristate "USB ZD1201 based Wireless device support"
 	depends on USB && WLAN_80211
@@ -540,7 +542,6 @@ endif # INTEL_80211
 source "drivers/net/wireless/hostap/Kconfig"
 source "drivers/net/wireless/b43/Kconfig"
 source "drivers/net/wireless/b43legacy/Kconfig"
-source "drivers/net/wireless/zd1211rw/Kconfig"
 source "drivers/net/wireless/rt2x00/Kconfig"
 source "drivers/net/wireless/orinoco/Kconfig"
 source "drivers/net/wireless/wl12xx/Kconfig"
-- 
1.6.2.5

