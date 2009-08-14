Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39442 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932845AbZHNU3v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 16:29:51 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v4 30/34] wireless: update WIRELESS_EXT kconfig entry
Date: Fri, 14 Aug 2009 16:25:55 -0400
Message-Id: <1250281559-13041-31-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
References: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Provide more documentation as to why its being deprecated.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/Kconfig |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 60dd09e..b07ed2c 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -86,8 +86,16 @@ config WIRELESS_EXT
 	bool "Wireless extensions"
 	default y
 	---help---
-	  This option enables the legacy wireless extensions
-	  (wireless network interface configuration via ioctls.)
+	  This option enables the legacy wireless extensions.
+	  Wireless extensions was the first 802.11 wireless configuration
+	  API used by the networking subsystem. You will not need this unless
+	  you have old userspace utilities or old wireless devices which
+	  have not yet been ported to cfg80211.
+
+	  Wireless extensions is being deprecated in favor for cfg80211. For
+	  information regarding why see the wireless wiki:
+
+	  http://wireless.kernel.org/en/developers/Documentation/Wireless-Extensions
 
 	  Say Y unless you've upgraded all your userspace to use
 	  nl80211 instead of wireless extensions.
-- 
1.6.2.5

