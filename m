Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:48398 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807Ab1HIVAG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 17:00:06 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: add cfg80211-wext.h
Date: Tue,  9 Aug 2011 22:59:42 +0200
Message-Id: <1312923582-31850-2-git-send-email-hauke@hauke-m.de> (sfid-20110809_230010_562715_992EF684)
In-Reply-To: <1312923582-31850-1-git-send-email-hauke@hauke-m.de>
References: <1312923582-31850-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This file was spitted out of include/net/cfg80211.h so we should
also ship it.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scripts/admin-update.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index be09111..3040275 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -32,7 +32,7 @@ INCLUDE_LINUX_USB="usbnet.h rndis_host.h"
 INCLUDE_LINUX_SPI="libertas_spi.h"
 
 # The good new yummy stuff
-INCLUDE_NET="cfg80211.h ieee80211_radiotap.h"
+INCLUDE_NET="cfg80211.h ieee80211_radiotap.h cfg80211-wext.h"
 INCLUDE_NET="$INCLUDE_NET mac80211.h lib80211.h regulatory.h"
 
 # Pretty colors
-- 
1.7.4.1

