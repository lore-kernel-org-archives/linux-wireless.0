Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53135 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757762AbZHQR1c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 13:27:32 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Michael Buesch <mb@bu3sch.de>,
	=?utf-8?q?G=C3=A1bor=20Stefanik?= <netrolller.3d@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH v5 11/33] wireless: clarify rndis_wlan is not broadcom specific
Date: Mon, 17 Aug 2009 13:27:10 -0400
Message-Id: <1250530052-14783-12-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
References: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: Michael Buesch <mb@bu3sch.de>
Cc: Gábor Stefanik <netrolller.3d@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index e910799..c557056 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -403,7 +403,10 @@ config USB_NET_RNDIS_WLAN
 	  BUFFALO WLI-USB-G54
 
 	  All of these devices are based on Broadcom 4320 chip which is the
-	  only wireless RNDIS chip known to date.
+	  only wireless RNDIS chip known to date. Technically RNDIS follows
+	  a Microsoft specification, and although only Broadcom currently
+	  supports this, other vendors could technically follow the
+	  implementation as well.
 
 	  If you choose to build a module, it'll be called rndis_wlan.
 
-- 
1.6.2.5

