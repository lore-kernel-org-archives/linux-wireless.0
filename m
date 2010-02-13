Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54891 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757605Ab0BMR0f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Feb 2010 12:26:35 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: update .gitignore
Date: Sat, 13 Feb 2010 18:26:27 +0100
Message-Id: <1266081988-16012-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 .gitignore |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/.gitignore b/.gitignore
index b6a26d3..e5266e6 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,15 +1,13 @@
 drivers
 include
 net
+compat
+udev
 *~
 git-describe
 compat-release
 master-tag
-.compat_autoconf*
-.config.md5
-.config.mk_md5sum.txt
-.tmp_versions
 Module.symvers
 module.order
-patches
 .pc
+
-- 
1.6.3.3

