Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45329 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529AbZHNAnF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 20:43:05 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 25/25] ath: be consistent with the other group driver entries
Date: Thu, 13 Aug 2009 20:43:04 -0400
Message-Id: <1250210584-13374-26-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250210584-13374-1-git-send-email-lrodriguez@atheros.com>
References: <1250210584-13374-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
index 9bfa909..b974b73 100644
--- a/drivers/net/wireless/ath/Kconfig
+++ b/drivers/net/wireless/ath/Kconfig
@@ -1,5 +1,5 @@
 menuconfig ATH_COMMON
-	tristate "Atheros Wireless Cards"
+	tristate "Atheros"
 	depends on CFG80211
 	---help---
 	  This will enable the support for the Atheros wireless drivers.
-- 
1.6.2.5

