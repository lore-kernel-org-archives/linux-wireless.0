Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57300 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbXLULVx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2007 06:21:53 -0500
Subject: [PATCH] ath5k: don't build by default
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain
Date: Fri, 21 Dec 2007 00:59:04 +0100
Message-Id: <1198195144.16241.65.camel@johannes.berg> (sfid-20071221_112158_638221_5D25FC11)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Must have been hubris, everybody needs ath5k, right?

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- everything.orig/drivers/net/wireless/Kconfig	2007-12-21 00:57:26.393161350 +0100
+++ everything/drivers/net/wireless/Kconfig	2007-12-21 00:57:29.913160862 +0100
@@ -664,7 +664,6 @@ config P54_PCI
 config ATH5K
 	tristate "Atheros 5xxx wireless cards support"
 	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
-	default m
 	---help---
 	  This module adds support for wireless adapters based on
 	  Atheros 5xxx chipset.


