Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60026 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984Ab1GVQu2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 12:50:28 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/5] compat-wireless: copy include/crypto/aes.h now
Date: Fri, 22 Jul 2011 18:50:14 +0200
Message-Id: <1311353415-30952-4-git-send-email-hauke@hauke-m.de> (sfid-20110722_185031_687721_FA093C8E)
In-Reply-To: <1311353415-30952-1-git-send-email-hauke@hauke-m.de>
References: <1311353415-30952-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scripts/admin-update.sh |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 74c177f..be09111 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -272,6 +272,7 @@ mkdir -p include/linux/ include/net/ include/linux/usb \
 	include/linux/spi \
 	include/trace \
 	include/pcmcia \
+	include/crypto \
 	net/mac80211/ net/wireless/ \
 	net/rfkill/ \
 	drivers/ssb/ \
@@ -411,6 +412,7 @@ cp -a $GIT_COMPAT_TREE/include/linux/* include/linux/
 cp -a $GIT_COMPAT_TREE/include/net/* include/net/
 cp -a $GIT_COMPAT_TREE/include/trace/* include/trace/
 cp -a $GIT_COMPAT_TREE/include/pcmcia/* include/pcmcia/
+cp -a $GIT_COMPAT_TREE/include/crypto/* include/crypto/
 rm -f $COMPAT/*.mod.c
 
 # files we suck in for compat-wireless
-- 
1.7.4.1

