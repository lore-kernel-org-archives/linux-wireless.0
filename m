Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39388 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932833AbZHNU3B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 16:29:01 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Kalle Valo <kalle.valo@nokia.com>,
	Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH v4 24/34] wireless: Update TI kconfig description
Date: Fri, 14 Aug 2009 16:25:49 -0400
Message-Id: <1250281559-13041-25-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
References: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
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
index 78029fd..46afa88 100644
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

