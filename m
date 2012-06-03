Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:57435 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab2FCOa2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jun 2012 10:30:28 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: add additional header file for bluetooth
Date: Sun,  3 Jun 2012 16:30:13 +0200
Message-Id: <1338733814-31438-1-git-send-email-hauke@hauke-m.de> (sfid-20120603_163104_879684_622BCD57)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a compile problem with all kernel versions.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scripts/admin-update.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index a52c908..c4f5e39 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -18,7 +18,7 @@
 GIT_URL="git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git"
 GIT_COMPAT_URL="git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat.git"
 
-INCLUDE_NET_BT="hci_core.h l2cap.h bluetooth.h rfcomm.h hci.h hci_mon.h mgmt.h sco.h smp.h"
+INCLUDE_NET_BT="hci_core.h l2cap.h bluetooth.h rfcomm.h hci.h hci_mon.h mgmt.h sco.h smp.h a2mp.h"
 NET_BT_DIRS="bluetooth bluetooth/bnep bluetooth/cmtp bluetooth/rfcomm bluetooth/hidp"
 
 INCLUDE_LINUX="ieee80211.h nl80211.h"
-- 
1.7.9.5

