Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13687 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbZHLVpQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 17:45:16 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 14:45:18 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<ath5k-devel@lists.ath5k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Dakota Lee <Dakota.Lee@Atheros.com>
Subject: [PATCH] ath9k: update kconfig to indicate support for AR9002 family
Date: Wed, 12 Aug 2009 14:45:16 -0700
Message-ID: <1250113516-16573-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k supports the AR9002 family of chipsets. This includes
the AR9285 and the miniPCI AR9223 and AR9220 (which themselves
have AR9280+AR5133).

We now refer people to the wiki page as it seems this is not
as popular as we would have hoped.

Reported-by: JD <jd1008@gmail.com>
Cc: Dakota Lee <Dakota.Lee@Atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 2cb72f8..ef5f59c 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -6,7 +6,13 @@ config ATH9K
 	select NEW_LEDS
 	---help---
 	  This module adds support for wireless adapters based on
-	  Atheros IEEE 802.11n AR5008 and AR9001 family of chipsets.
+	  Atheros IEEE 802.11n AR5008, AR9001 and AR9002 family
+	  of chipsets. For a specific list of supported external
+	  cards, laptops that already ship with these cards and
+	  APs that come with these cards refer to to ath9k wiki
+	  products page:
+
+	  http://wireless.kernel.org/en/users/Drivers/ath9k/products
 
 	  If you choose to build a module, it'll be called ath9k.
 
-- 
1.6.3.3

