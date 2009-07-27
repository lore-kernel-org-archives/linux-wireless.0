Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:60490 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbZG0XwU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 19:52:20 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 16:52:21 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath5k: remove EXPERIMENTAL marker
Date: Mon, 27 Jul 2009 16:52:09 -0700
Message-ID: <1248738730-4003-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1248738730-4003-1-git-send-email-lrodriguez@atheros.com>
References: <1248738730-4003-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath5k/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/Kconfig b/drivers/net/wireless/ath/ath5k/Kconfig
index 9b07eef..06d0066 100644
--- a/drivers/net/wireless/ath/ath5k/Kconfig
+++ b/drivers/net/wireless/ath/ath5k/Kconfig
@@ -1,6 +1,6 @@
 config ATH5K
 	tristate "Atheros 5xxx wireless cards support"
-	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
+	depends on PCI && MAC80211 && WLAN_80211
 	select MAC80211_LEDS
 	select LEDS_CLASS
 	select NEW_LEDS
-- 
1.6.0.4

