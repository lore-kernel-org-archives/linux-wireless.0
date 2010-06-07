Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50423 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239Ab0FGGOn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 02:14:43 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH] wireless: remove my name from the maintainer list
Date: Mon,  7 Jun 2010 14:15:43 +0800
Message-Id: <1275891343-11931-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove my name from the MAINTAINERS file.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 MAINTAINERS |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 13608bd..d7c467a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2978,7 +2978,6 @@ F:	drivers/net/ixgb/
 F:	drivers/net/ixgbe/
 
 INTEL PRO/WIRELESS 2100 NETWORK CONNECTION SUPPORT
-M:	Zhu Yi <yi.zhu@intel.com>
 M:	Reinette Chatre <reinette.chatre@intel.com>
 M:	Intel Linux Wireless <ilw@linux.intel.com>
 L:	linux-wireless@vger.kernel.org
@@ -2988,7 +2987,6 @@ F:	Documentation/networking/README.ipw2100
 F:	drivers/net/wireless/ipw2x00/ipw2100.*
 
 INTEL PRO/WIRELESS 2915ABG NETWORK CONNECTION SUPPORT
-M:	Zhu Yi <yi.zhu@intel.com>
 M:	Reinette Chatre <reinette.chatre@intel.com>
 M:	Intel Linux Wireless <ilw@linux.intel.com>
 L:	linux-wireless@vger.kernel.org
@@ -3019,7 +3017,6 @@ F:	drivers/net/wimax/i2400m/
 F:	include/linux/wimax/i2400m.h
 
 INTEL WIRELESS WIFI LINK (iwlwifi)
-M:	Zhu Yi <yi.zhu@intel.com>
 M:	Reinette Chatre <reinette.chatre@intel.com>
 M:	Intel Linux Wireless <ilw@linux.intel.com>
 L:	linux-wireless@vger.kernel.org
@@ -3030,7 +3027,6 @@ F:	drivers/net/wireless/iwlwifi/
 
 INTEL WIRELESS MULTICOMM 3200 WIFI (iwmc3200wifi)
 M:	Samuel Ortiz <samuel.ortiz@intel.com>
-M:	Zhu Yi <yi.zhu@intel.com>
 M:	Intel Linux Wireless <ilw@linux.intel.com>
 L:	linux-wireless@vger.kernel.org
 S:	Supported
-- 
1.6.3.3

