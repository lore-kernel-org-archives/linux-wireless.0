Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39305 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460Ab2DZSIQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 14:08:16 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC c 2/9] compat: include compat_autoconf.h
Date: Thu, 26 Apr 2012 20:07:44 +0200
Message-Id: <1335463674-13003-4-git-send-email-hauke@hauke-m.de> (sfid-20120426_200821_416415_D5928B18)
In-Reply-To: <1335463674-13003-1-git-send-email-hauke@hauke-m.de>
References: <1335463674-13003-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/generated/autoconf.h |    2 ++
 1 file changed, 2 insertions(+)
 create mode 100644 include/generated/autoconf.h

diff --git a/include/generated/autoconf.h b/include/generated/autoconf.h
new file mode 100644
index 0000000..a4064e3
--- /dev/null
+++ b/include/generated/autoconf.h
@@ -0,0 +1,2 @@
+#include_next <generated/autoconf.h>
+#include <linux/compat_autoconf.h>
-- 
1.7.9.5

