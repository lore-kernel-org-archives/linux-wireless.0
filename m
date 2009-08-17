Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53161 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbZHQR1d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 13:27:33 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v5 28/33] wireless: update wireless kconfig description
Date: Mon, 17 Aug 2009 13:27:27 -0400
Message-Id: <1250530052-14783-29-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
References: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Wireless" is a misnomer 802.11 as there are plently
of other wireless technologies. Be more specific and refer
people to our good hearty wireless wiki for documentation.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/Kconfig |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/net/Kconfig b/net/Kconfig
index 041c35e..31c208d 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -260,9 +260,15 @@ config FIB_RULES
 	bool
 
 menuconfig WIRELESS
-	bool "Wireless"
+	bool "IEEE 802.11 - Wireless LAN"
 	depends on !S390
 	default y
+	---help---
+	  This allows you to enable different parts of the networking subsystem
+	  to support IEEE 802.11 Wireless LAN networks. For news and
+	  documentation refer to the wireless wiki:
+
+	  http://wireless.kernel.org
 
 if WIRELESS
 
-- 
1.6.2.5

