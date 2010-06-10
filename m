Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50741 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758506Ab0FJBnJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jun 2010 21:43:09 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH] wireless: orphan ipw2x00 drivers
Date: Thu, 10 Jun 2010 09:44:29 +0800
Message-Id: <1276134269-2273-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
Please let us know if someone is interested in maintaining these drivers.

 MAINTAINERS |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6d119c9..bef7c1a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2978,20 +2978,14 @@ F:	drivers/net/ixgb/
 F:	drivers/net/ixgbe/
 
 INTEL PRO/WIRELESS 2100 NETWORK CONNECTION SUPPORT
-M:	Reinette Chatre <reinette.chatre@intel.com>
-M:	Intel Linux Wireless <ilw@linux.intel.com>
 L:	linux-wireless@vger.kernel.org
-W:	http://ipw2100.sourceforge.net
-S:	Odd Fixes
+S:	Orphan
 F:	Documentation/networking/README.ipw2100
 F:	drivers/net/wireless/ipw2x00/ipw2100.*
 
 INTEL PRO/WIRELESS 2915ABG NETWORK CONNECTION SUPPORT
-M:	Reinette Chatre <reinette.chatre@intel.com>
-M:	Intel Linux Wireless <ilw@linux.intel.com>
 L:	linux-wireless@vger.kernel.org
-W:	http://ipw2200.sourceforge.net
-S:	Odd Fixes
+S:	Orphan
 F:	Documentation/networking/README.ipw2200
 F:	drivers/net/wireless/ipw2x00/ipw2200.*
 
-- 
1.6.3.3

