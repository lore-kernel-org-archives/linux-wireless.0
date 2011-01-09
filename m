Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54124 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab1AIPcg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jan 2011 10:32:36 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat-wireless: do not write git-clone
Date: Sun,  9 Jan 2011 16:32:21 +0100
Message-Id: <1294587141-11353-4-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1294587141-11353-1-git-send-email-hauke@hauke-m.de>
References: <1294587141-11353-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

the command git-clone was removed and git clone should be used now.
Update error message.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scripts/admin-update.sh |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index bf8e080..650c489 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -191,7 +191,7 @@ if [ -z $GIT_TREE ]; then
 		echo "  export GIT_TREE=/home/$USER/linux-next/"
 		echo
 		echo "If you do not have one you can clone the repository:"
-		echo "  git-clone $GIT_URL"
+		echo "  git clone $GIT_URL"
 		exit 1
 	fi
 else
@@ -207,7 +207,7 @@ if [ -z $GIT_COMPAT_TREE ]; then
 		echo "  export GIT_COMPAT_TREE=/home/$USER/compat/"
 		echo
 		echo "If you do not have one you can clone the repository:"
-		echo "  git-clone $GIT_COMPAT_URL"
+		echo "  git clone $GIT_COMPAT_URL"
 		exit 1
 	fi
 else
-- 
1.7.1

