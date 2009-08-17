Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53165 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757827AbZHQR1d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 13:27:33 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v5 29/33] wireless: update cfg80211 kconfig entry
Date: Mon, 17 Aug 2009 13:27:28 -0400
Message-Id: <1250530052-14783-30-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
References: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211 is now *the* wireless configuration API. Lets also
give a little explanation as to what it is and refer people to
the wireless wiki for more information.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/Kconfig |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index c6031d5..1591e2b 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -1,6 +1,15 @@
 config CFG80211
-	tristate "Improved wireless configuration API"
+	tristate "cfg80211 - wireless configuration API"
 	depends on RFKILL || !RFKILL
+	---help---
+	  cfg80211 is the Linux wireless LAN (802.11) configuration API.
+	  Enable this if you have a wireless device.
+
+	  For more information refer to documentation on the wireless wiki:
+
+	  http://wireless.kernel.org/en/developers/Documentation/cfg80211
+
+	  When built as a module cfg80211 will be built as cfg80211
 
 config NL80211_TESTMODE
 	bool "nl80211 testmode command"
-- 
1.6.2.5

