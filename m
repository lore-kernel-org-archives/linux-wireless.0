Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33091 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756547Ab1FIWEW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 18:04:22 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, jonas.gorski@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 10/11] compat-wireless: add missing bluetooth header
Date: Fri, 10 Jun 2011 00:03:41 +0200
Message-Id: <1307657022-23808-11-git-send-email-hauke@hauke-m.de> (sfid-20110610_000438_761911_8BDA727C)
In-Reply-To: <1307657022-23808-1-git-send-email-hauke@hauke-m.de>
References: <1307657022-23808-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scripts/admin-update.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index de810b5..df7056e 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -18,7 +18,7 @@
 GIT_URL="git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git"
 GIT_COMPAT_URL="git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat.git"
 
-INCLUDE_NET_BT="hci_core.h l2cap.h bluetooth.h rfcomm.h hci.h mgmt.h"
+INCLUDE_NET_BT="hci_core.h l2cap.h bluetooth.h rfcomm.h hci.h mgmt.h smp.h"
 NET_BT_DIRS="bluetooth bluetooth/bnep bluetooth/cmtp bluetooth/rfcomm bluetooth/hidp"
 
 INCLUDE_LINUX="ieee80211.h nl80211.h"
-- 
1.7.4.1

