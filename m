Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53173 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757840AbZHQR1d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 13:27:33 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v5 30/33] wireless: update reg debug kconfig entry
Date: Mon, 17 Aug 2009 13:27:29 -0400
Message-Id: <1250530052-14783-31-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
References: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refer to the wireless wiki for more information.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/Kconfig |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 1591e2b..991e177 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -32,6 +32,10 @@ config CFG80211_REG_DEBUG
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

