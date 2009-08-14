Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39421 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932841AbZHNU3a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 16:29:30 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v4 28/34] wireless: update cfg80211 kconfig entry
Date: Fri, 14 Aug 2009 16:25:53 -0400
Message-Id: <1250281559-13041-29-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
References: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211 is now *the* wireless configuration API. Lets also
give a little explanation as to what it is and refer people to
the wireless wiki for more information.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/Kconfig |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index c6031d5..e060b87 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -1,5 +1,19 @@
 config CFG80211
-	tristate "Improved wireless configuration API"
+	tristate "cfg80211 - wireless configuration API"
+	---help---
+	  cfg80211 is the Linux wireless LAN (802.11) configuration API.
+	  Enable this if you have a wireless device or if you just want
+	  to test the wireless subsystem (see mac80211_hwsim). cfg80211
+	  allows for device drivers to register themselves with the
+	  networking subsystem and allows for userspace configuration
+	  through a generic netlink family for wireless called nl80211.
+
+	  For more information refer to documentation on the wireless wiki:
+
+	  http://wireless.kernel.org/en/developers/Documentation/cfg80211
+
+	  When built as a module cfg80211 will be built as cfg80211.ko
+
 	depends on RFKILL || !RFKILL
 
 config NL80211_TESTMODE
-- 
1.6.2.5

