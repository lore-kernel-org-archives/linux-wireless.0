Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33054 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756640Ab1FIWEH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 18:04:07 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, jonas.gorski@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 05/11] compat-wireless: add missing header
Date: Fri, 10 Jun 2011 00:03:36 +0200
Message-Id: <1307657022-23808-6-git-send-email-hauke@hauke-m.de> (sfid-20110610_000412_186917_84B8088F)
In-Reply-To: <1307657022-23808-1-git-send-email-hauke@hauke-m.de>
References: <1307657022-23808-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds mac80211_hwsim.h

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scripts/admin-update.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index ea123ca..de810b5 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -259,7 +259,7 @@ DRIVERS_BT="drivers/bluetooth"
 # Drivers that belong the the wireless directory
 DRIVER_FILES="adm8211.c  adm8211.h"
 DRIVER_FILES="$DRIVER_FILES rndis_wlan.c"
-DRIVER_FILES="$DRIVER_FILES mac80211_hwsim.c"
+DRIVER_FILES="$DRIVER_FILES mac80211_hwsim.c mac80211_hwsim.h"
 DRIVER_FILES="$DRIVER_FILES at76c50x-usb.c at76c50x-usb.h"
 DRIVER_FILES="$DRIVER_FILES mwl8k.c"
 
-- 
1.7.4.1

