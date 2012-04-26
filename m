Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39332 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670Ab2DZSI2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 14:08:28 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC c-w 4/4] compat-wireless: copy *.h files from compat/compat
Date: Thu, 26 Apr 2012 20:07:49 +0200
Message-Id: <1335463674-13003-9-git-send-email-hauke@hauke-m.de> (sfid-20120426_200832_927408_85DAE00B)
In-Reply-To: <1335463674-13003-1-git-send-email-hauke@hauke-m.de>
References: <1335463674-13003-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scripts/admin-update.sh |    1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 7147ff1..6dd0c01 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -429,6 +429,7 @@ COMPAT="compat"
 mkdir -p $COMPAT
 echo "Copying $GIT_COMPAT_TREE/ files..."
 cp $GIT_COMPAT_TREE/compat/*.c $COMPAT/
+cp $GIT_COMPAT_TREE/compat/*.h $COMPAT/
 cp $GIT_COMPAT_TREE/compat/Makefile $COMPAT/
 cp -a $GIT_COMPAT_TREE/udev .
 cp -a $GIT_COMPAT_TREE/scripts $COMPAT/
-- 
1.7.9.5

