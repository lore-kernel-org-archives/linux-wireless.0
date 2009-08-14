Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39432 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932834AbZHNU3g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 16:29:36 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v4 29/34] wireless: update reg debug kconfig entry
Date: Fri, 14 Aug 2009 16:25:54 -0400
Message-Id: <1250281559-13041-30-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
References: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refer to the wireless wiki for more information.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/Kconfig |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index e060b87..60dd09e 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -37,6 +37,10 @@ config CFG80211_REG_DEBUG
 	default n
 	---help---
 	  You can enable this if you want to debug regulatory changes.
+	  For more information on cfg80211 regulatory refer to the wireless
+	  wiki:
+
+	  http://wireless.kernel.org/en/developers/Regulatory
 
 	  If unsure, say N.
 
-- 
1.6.2.5

