Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:49374 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab0LJXC5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 18:02:57 -0500
Subject: [PATCH] compat-wireless: copy new bluetooth header file
From: Timo Lindhorst <TimoLindhorst@web.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Date: Sat, 11 Dec 2010 00:02:49 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201012110002.49704.TimoLindhorst@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the header file for the new bluetooth management interface to the
list of bluetooth include files.

Signed-off-by: Timo Lindhorst <TimoLindhorst@web.de>
---
 scripts/admin-update.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 703d132..2547928 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -18,7 +18,7 @@
 GIT_URL="git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git"
 GIT_COMPAT_URL="git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat.git"
 
-INCLUDE_NET_BT="hci_core.h l2cap.h bluetooth.h rfcomm.h hci.h"
+INCLUDE_NET_BT="hci_core.h l2cap.h bluetooth.h rfcomm.h hci.h mgmt.h"
 NET_BT_DIRS="bluetooth bluetooth/bnep bluetooth/cmtp bluetooth/rfcomm bluetooth/hidp"
 
 INCLUDE_LINUX="ieee80211.h nl80211.h"
-- 
1.7.2.3

