Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:29646 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302Ab0DBUi7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Apr 2010 16:38:59 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/7] iwlwifi: deprecate "iwl4965" alias support
Date: Fri,  2 Apr 2010 13:38:51 -0700
Message-Id: <1270240734-12825-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1270240734-12825-1-git-send-email-reinette.chatre@intel.com>
References: <1270240734-12825-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Internal alias support has been present in module-init-tools for some
time, the MODULE_ALIAS("iwl4965") boilerplate aliases can be removed.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 Documentation/feature-removal-schedule.txt |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 4e78611..d46944f 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -556,3 +556,15 @@ Why:	The "..50" modules parameters were used to configure 5000 series and
 	in drivers/net/wireless/iwlwifi/iwl-agn.c
 
 Who:	Wey-Yi Guy <wey-yi.w.guy@intel.com>
+
+----------------------------
+
+What:	iwl4965 alias support
+When:	2.6.40
+Why:	Internal alias support has been present in module-init-tools for some
+	time, the MODULE_ALIAS("iwl4965") boilerplate aliases can be removed
+	with no impact.
+
+Who:	Wey-Yi Guy <wey-yi.w.guy@intel.com>
+
+----------------------------
-- 
1.6.3.3

