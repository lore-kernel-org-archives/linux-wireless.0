Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45336 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534AbZHNAnF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 20:43:05 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Michael Buesch <mb@bu3sch.de>,
	=?utf-8?q?G=C3=A1bor=20Stefanik?= <netrolller.3d@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH v2 11/25] wireless: clarify rndis_wlan is not broadcom specific
Date: Thu, 13 Aug 2009 20:42:50 -0400
Message-Id: <1250210584-13374-12-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250210584-13374-1-git-send-email-lrodriguez@atheros.com>
References: <1250210584-13374-1-git-send-email-lrodriguez@atheros.com>
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
 drivers/net/wireless/Kconfig |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index cb5aae6..a1bdb51 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -403,7 +403,9 @@ config USB_NET_RNDIS_WLAN
 	  BUFFALO WLI-USB-G54
 
 	  All of these devices are based on Broadcom 4320 chip which is the
-	  only wireless RNDIS chip known to date.
+	  only wireless RNDIS chip known to date. Technically RNDIS follows
+	  a specification and although only Broadcom currently supports this
+	  other vendors could technically follow the implementation as well.
 
 	  If you choose to build a module, it'll be called rndis_wlan.
 
-- 
1.6.2.5

