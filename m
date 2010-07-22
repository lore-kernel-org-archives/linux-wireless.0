Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54823 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab0GVSaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 14:30:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] MAINTAINERS: mark prism54 obsolete
Date: Thu, 22 Jul 2010 14:27:43 -0400
Message-Id: <1279823263-21201-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The prism54 driver had an entry in feature-removal-schedule.txt and it
sees very little activity other than API-change "bombing runs".  The
mac80211-based p54 driver should be used instead.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7faf729..3148b71 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4499,7 +4499,7 @@ PRISM54 WIRELESS DRIVER
 M:	"Luis R. Rodriguez" <mcgrof@gmail.com>
 L:	linux-wireless@vger.kernel.org
 W:	http://prism54.org
-S:	Maintained
+S:	Obsolete
 F:	drivers/net/wireless/prism54/
 
 PROMISE DC4030 CACHING DISK CONTROLLER DRIVER
-- 
1.7.1.1

