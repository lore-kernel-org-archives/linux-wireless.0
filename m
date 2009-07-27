Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:60497 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbZG0XwY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 19:52:24 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 16:52:25 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Christian Lamparter <chunkeey@web.de>
Subject: [PATCH] ar9170: remove EXPERIMENTAL marker
Date: Mon, 27 Jul 2009 16:52:10 -0700
Message-ID: <1248738730-4003-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1248738730-4003-1-git-send-email-lrodriguez@atheros.com>
References: <1248738730-4003-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: Christian Lamparter <chunkeey@web.de>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ar9170/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/Kconfig b/drivers/net/wireless/ath/ar9170/Kconfig
index de4281f..05918f1 100644
--- a/drivers/net/wireless/ath/ar9170/Kconfig
+++ b/drivers/net/wireless/ath/ar9170/Kconfig
@@ -1,12 +1,13 @@
 config AR9170_USB
 	tristate "Atheros AR9170 802.11n USB support"
-	depends on USB && MAC80211 && WLAN_80211 && EXPERIMENTAL
+	depends on USB && MAC80211 && WLAN_80211
 	select FW_LOADER
 	help
 	  This is a driver for the Atheros "otus" 802.11n USB devices.
 
 	  These devices require additional firmware (2 files).
 	  For now, these files can be downloaded from here:
+
 	  http://wireless.kernel.org/en/users/Drivers/ar9170
 
 	  If you choose to build a module, it'll be called ar9170usb.
-- 
1.6.0.4

