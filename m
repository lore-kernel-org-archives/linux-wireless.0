Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53150 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757718AbZHQR1c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 13:27:32 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Kalle Valo <kalle.valo@nokia.com>,
	Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH v5 24/33] wireless: Update TI kconfig description
Date: Mon, 17 Aug 2009 13:27:23 -0400
Message-Id: <1250530052-14783-25-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
References: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Other TI drivers can land here now.

Cc: Kalle Valo <kalle.valo@nokia.com>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/wl12xx/Kconfig |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index ef250e9..021bcdf 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -1,9 +1,8 @@
 config WL12XX
-	boolean "TI wl12xx driver support"
+	boolean "Texas Instruments"
 	depends on MAC80211 && EXPERIMENTAL
 	---help---
-	  This will enable TI wl12xx driver support. The drivers make
-	  use of the mac80211 stack.
+	  This will enable support for Texas Instruments wireless chipsets.
 
 if WL12XX
 
-- 
1.6.2.5

