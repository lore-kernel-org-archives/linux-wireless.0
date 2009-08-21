Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9226 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932665AbZHUUea (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 16:34:30 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	James Ketrenos <jketreno@linux.intel.com>
Subject: [PATCH 14/14] MAINTAINERS: Update ipw2x00 and iwlwifi entries
Date: Fri, 21 Aug 2009 13:34:27 -0700
Message-Id: <1250886867-4112-15-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1250886867-4112-1-git-send-email-reinette.chatre@intel.com>
References: <1250886867-4112-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Update MAINTAINERS file to reflect current maintenance status of ipw2x00
drivers. We remove James's name as he is not involved with this project
anymore. We also update the Status to "Odd Fixes". This has been true for a
while now, we have to make it official. There is also a new email address
with which all relevant people can be reached. The same email address
should be used for iwlwifi.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: James Ketrenos <jketreno@linux.intel.com>
Acked-by: James Ketrenos <jketreno@linux.intel.com>
Acked-by: Zhu Yi <yi.zhu@intel.com>
---
 MAINTAINERS |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8d8d495..a8b8d28 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2653,25 +2653,21 @@ F:	drivers/net/ixgbe/
 
 INTEL PRO/WIRELESS 2100 NETWORK CONNECTION SUPPORT
 M:	Zhu Yi <yi.zhu@intel.com>
-M:	James Ketrenos <jketreno@linux.intel.com>
 M:	Reinette Chatre <reinette.chatre@intel.com>
+M:	ilw@linux.intel.com
 L:	linux-wireless@vger.kernel.org
-L:	ipw2100-devel@lists.sourceforge.net
-W:	http://lists.sourceforge.net/mailman/listinfo/ipw2100-devel
 W:	http://ipw2100.sourceforge.net
-S:	Supported
+S:	Odd Fixes
 F:	Documentation/networking/README.ipw2100
 F:	drivers/net/wireless/ipw2x00/ipw2100.*
 
 INTEL PRO/WIRELESS 2915ABG NETWORK CONNECTION SUPPORT
 M:	Zhu Yi <yi.zhu@intel.com>
-M:	James Ketrenos <jketreno@linux.intel.com>
 M:	Reinette Chatre <reinette.chatre@intel.com>
+M:	ilw@linux.intel.com
 L:	linux-wireless@vger.kernel.org
-L:	ipw2100-devel@lists.sourceforge.net
-W:	http://lists.sourceforge.net/mailman/listinfo/ipw2100-devel
 W:	http://ipw2200.sourceforge.net
-S:	Supported
+S:	Odd Fixes
 F:	Documentation/networking/README.ipw2200
 F:	drivers/net/wireless/ipw2x00/ipw2200.*
 
@@ -2688,8 +2684,8 @@ F:	include/linux/wimax/i2400m.h
 INTEL WIRELESS WIFI LINK (iwlwifi)
 M:	Zhu Yi <yi.zhu@intel.com>
 M:	Reinette Chatre <reinette.chatre@intel.com>
+M:	ilw@linux.intel.com
 L:	linux-wireless@vger.kernel.org
-L:	ipw3945-devel@lists.sourceforge.net
 W:	http://intellinuxwireless.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
 S:	Supported
-- 
1.5.6.3

