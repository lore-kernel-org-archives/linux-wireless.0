Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756675Ab1KRIWg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:22:36 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8Mank015853
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:22:36 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 49/77] iwlegacy: rename module name
Date: Fri, 18 Nov 2011 09:22:11 +0100
Message-Id: <1321604559-10707-49-git-send-email-sgruszka@redhat.com> (sfid-20111118_092242_427759_DCFFDD07)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/Makefile |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/Makefile b/drivers/net/wireless/iwlegacy/Makefile
index 413213b..7421841 100644
--- a/drivers/net/wireless/iwlegacy/Makefile
+++ b/drivers/net/wireless/iwlegacy/Makefile
@@ -1,8 +1,8 @@
-obj-$(CONFIG_IWLEGACY)	+= iwl-legacy.o
-iwl-legacy-objs 		:= common.o
-iwl-legacy-$(CONFIG_IWLEGACY_DEBUGFS) += iwl-debugfs.o
+obj-$(CONFIG_IWLEGACY)	+= iwlegacy.o
+iwlegacy-objs 		:= common.o
+iwlegacy-$(CONFIG_IWLEGACY_DEBUGFS) += iwl-debugfs.o
 
-iwl-legacy-objs += $(iwl-legacy-m)
+iwlegacy-objs += $(iwlegacy-m)
 
 # 4965
 obj-$(CONFIG_IWL4965)	+= iwl4965.o
-- 
1.7.1

