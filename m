Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:39262 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab2FULwb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 07:52:31 -0400
Received: by qabj40 with SMTP id j40so1374506qab.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jun 2012 04:52:30 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH] compat: Suck in ckmake from compat.git
Date: Thu, 21 Jun 2012 14:52:22 +0300
Message-Id: <1340279542-31817-1-git-send-email-ozancag@gmail.com> (sfid-20120621_135234_417606_51D34726)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ckmake can be used directly to test compat-foo trees against the
installed kernel trees. So it is good to have it copied under
this tree.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 scripts/admin-update.sh |    1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 7daec31..ec87f98 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -435,6 +435,7 @@ cp $GIT_COMPAT_TREE/compat/*.[ch] $COMPAT/
 cp $GIT_COMPAT_TREE/compat/Makefile $COMPAT/
 cp -a $GIT_COMPAT_TREE/udev .
 cp -a $GIT_COMPAT_TREE/scripts $COMPAT/
+cp $GIT_COMPAT_TREE/bin/ckmake $COMPAT/
 cp -a $GIT_COMPAT_TREE/include/linux/* include/linux/
 cp -a $GIT_COMPAT_TREE/include/net/* include/net/
 cp -a $GIT_COMPAT_TREE/include/trace/* include/trace/
-- 
1.7.10.2

