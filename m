Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54367 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854Ab2FKWPG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 18:15:06 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, ozancag@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2] compat-wireless: update some urls to git trees in docs
Date: Tue, 12 Jun 2012 00:13:49 +0200
Message-Id: <1339452829-10194-1-git-send-email-hauke@hauke-m.de> (sfid-20120612_001511_131121_C8284B87)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes some references to compat and compat-wireless git tree hosted
at git.kernel.org to github and changed some references from wireless-
testing to linux-next and linux-2.6-allstable to linux-stable.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 README                        |    4 ++--
 scripts/admin-update.sh       |   16 ++++++++--------
 scripts/gen-stable-release.sh |    4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

v2: fix linux-nex.git typo

diff --git a/README b/README
index 09d8612..2cbef56 100644
--- a/README
+++ b/README
@@ -302,8 +302,8 @@ compatibility. You will then need to checkout three trees to start hacking on
 compat-wireless:
 
 git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
-git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat.git
-git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6.git
+git://github.com/mcgrof/compat.git
+git://github.com/mcgrof/compat-wireless.git
 
 Linux next
 ----------
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index c4f5e39..be564cc 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -2,21 +2,21 @@
 # 
 # Copyright 2007, 2008, 2010	Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
 #
-# Use this to update compat-wireless-2.6 to the latest
-# wireless-testing.git tree you have.
+# Use this to update compat-wireless to the latest
+# linux-next.git tree you have.
 #
-# Usage: you should have the latest pull of wireless-2.6.git
-# git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
-# We assume you have it on your ~/devel/wireless-testing/ directory. If you do,
-# just run this script from the compat-wireless-2.6 directory.
+# Usage: you should have the latest pull of linux-next.git
+# git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
+# We assume you have it on your ~/linux-next/ directory. If you do,
+# just run this script from the compat-wireless directory.
 # You can specify where your GIT_TREE is by doing:
 #
-# export GIT_TREE=/home/mcgrof/wireless-testing/
+# export GIT_TREE=/home/mcgrof/linux-next/
 # 
 # for example
 #
 GIT_URL="git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git"
-GIT_COMPAT_URL="git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat.git"
+GIT_COMPAT_URL="git://github.com/mcgrof/compat.git"
 
 INCLUDE_NET_BT="hci_core.h l2cap.h bluetooth.h rfcomm.h hci.h hci_mon.h mgmt.h sco.h smp.h a2mp.h"
 NET_BT_DIRS="bluetooth bluetooth/bnep bluetooth/cmtp bluetooth/rfcomm bluetooth/hidp"
diff --git a/scripts/gen-stable-release.sh b/scripts/gen-stable-release.sh
index 9764730..98f4af0 100755
--- a/scripts/gen-stable-release.sh
+++ b/scripts/gen-stable-release.sh
@@ -3,8 +3,8 @@
 #
 # You can use this to make stable compat-wireless releases
 #
-# The assumption is you have the linux-2.6-allstable git tree on your $HOME
-# git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-allstable.git
+# The assumption is you have the linux-stable git tree on your $HOME
+# git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
 #
 # Local branches will be created based on the remote linux-2.6.X.y branches.
 # If your branch already exists we will nuke it for you to avoid rebasing.
-- 
1.7.9.5

