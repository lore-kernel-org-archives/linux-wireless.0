Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10861 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989AbZIAPWr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 11:22:47 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2009 08:22:50 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/7] wireless: update wireless kconfig description
Date: Tue, 1 Sep 2009 08:22:41 -0700
Message-ID: <1251818566-9264-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1251818566-9264-1-git-send-email-lrodriguez@atheros.com>
References: <1251818566-9264-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
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
1.6.3.3

