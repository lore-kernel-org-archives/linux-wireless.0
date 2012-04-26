Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39315 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758306Ab2DZSIS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 14:08:18 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC c-w 2/4] compat-wireless: also copy include/generated/ from compat
Date: Thu, 26 Apr 2012 20:07:45 +0200
Message-Id: <1335463674-13003-5-git-send-email-hauke@hauke-m.de> (sfid-20120426_200823_435891_885FB2C4)
In-Reply-To: <1335463674-13003-1-git-send-email-hauke@hauke-m.de>
References: <1335463674-13003-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scripts/admin-update.sh |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index fd1fa87..7147ff1 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -283,6 +283,7 @@ mkdir -p include/linux/ include/net/ include/linux/usb \
 	include/trace \
 	include/pcmcia \
 	include/crypto \
+	include/generated \
 	net/mac80211/ net/wireless/ \
 	net/rfkill/ \
 	drivers/ssb/ \
@@ -436,6 +437,7 @@ cp -a $GIT_COMPAT_TREE/include/net/* include/net/
 cp -a $GIT_COMPAT_TREE/include/trace/* include/trace/
 cp -a $GIT_COMPAT_TREE/include/pcmcia/* include/pcmcia/
 cp -a $GIT_COMPAT_TREE/include/crypto/* include/crypto/
+cp -a $GIT_COMPAT_TREE/include/generated/* include/generated/
 rm -f $COMPAT/*.mod.c
 
 # files we suck in for compat-wireless
-- 
1.7.9.5

