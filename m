Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53096 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455AbZHQR1b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 13:27:31 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Zhu Yi <yi.zhu@intel.com>, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH v5 01/33] wireless: move iwmc3200wifi closer to the other intel drivers
Date: Mon, 17 Aug 2009 13:27:00 -0400
Message-Id: <1250530052-14783-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
References: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: Zhu Yi <yi.zhu@intel.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index dda7cc2..72dbac6 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -497,6 +497,7 @@ source "drivers/net/wireless/p54/Kconfig"
 source "drivers/net/wireless/ath/Kconfig"
 source "drivers/net/wireless/ipw2x00/Kconfig"
 source "drivers/net/wireless/iwlwifi/Kconfig"
+source "drivers/net/wireless/iwmc3200wifi/Kconfig"
 source "drivers/net/wireless/hostap/Kconfig"
 source "drivers/net/wireless/b43/Kconfig"
 source "drivers/net/wireless/b43legacy/Kconfig"
@@ -504,6 +505,5 @@ source "drivers/net/wireless/zd1211rw/Kconfig"
 source "drivers/net/wireless/rt2x00/Kconfig"
 source "drivers/net/wireless/orinoco/Kconfig"
 source "drivers/net/wireless/wl12xx/Kconfig"
-source "drivers/net/wireless/iwmc3200wifi/Kconfig"
 
 endmenu
-- 
1.6.2.5

