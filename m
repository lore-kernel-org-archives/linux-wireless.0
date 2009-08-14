Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45326 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528AbZHNAnF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 20:43:05 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Kalle Valo <kalle.valo@nokia.com>,
	Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH v2 24/25] wl12xx: be consistent with the other group driver entries
Date: Thu, 13 Aug 2009 20:43:03 -0400
Message-Id: <1250210584-13374-25-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250210584-13374-1-git-send-email-lrodriguez@atheros.com>
References: <1250210584-13374-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Other TI drivers can land here now.

Cc: Kalle Valo <kalle.valo@nokia.com>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/wl12xx/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index 78029fd..f4510f7 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -1,5 +1,5 @@
 config WL12XX
-	boolean "TI wl12xx driver support"
+	boolean "Texas Instruments"
 	depends on MAC80211 && EXPERIMENTAL
 	---help---
 	  This will enable TI wl12xx driver support. The drivers make
-- 
1.6.2.5

