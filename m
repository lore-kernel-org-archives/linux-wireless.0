Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:40795 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241Ab2HKAaT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 20:30:19 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org,
	lf_driver_backport@lists.linux-foundation.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/4] compat: generate CONFIG_COMPAT_KERNEL_3_7
Date: Sat, 11 Aug 2012 02:30:05 +0200
Message-Id: <1344645007-26757-3-git-send-email-hauke@hauke-m.de> (sfid-20120811_023024_717570_1DD19A8B)
In-Reply-To: <1344645007-26757-1-git-send-email-hauke@hauke-m.de>
References: <1344645007-26757-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scripts/gen-compat-config.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gen-compat-config.sh b/scripts/gen-compat-config.sh
index 3eba34e..391a75d 100755
--- a/scripts/gen-compat-config.sh
+++ b/scripts/gen-compat-config.sh
@@ -17,7 +17,7 @@ fi
 KERNEL_VERSION=$(${MAKE} -C ${KLIB_BUILD} kernelversion | sed -n 's/^\([0-9]\)\..*/\1/p')
 
 # 3.0 kernel stuff
-COMPAT_LATEST_VERSION="5"
+COMPAT_LATEST_VERSION="7"
 KERNEL_SUBLEVEL="-1"
 
 # Note that this script will export all variables explicitly,
-- 
1.7.9.5

