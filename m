Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:64184 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbYDJUTS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2008 16:19:18 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] MAINTAINERS: move to generic repository for iwlwifi
Date: Thu, 10 Apr 2008 13:16:27 -0700
Message-Id: <1207858587-14503-1-git-send-email-reinette.chatre@intel.com> (sfid-20080410_211925_078274_6B858569)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
John,

Is it possible to get this laggard into 2.6.25?

 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9e63f16..d7c62b2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2116,7 +2116,7 @@ M:	reinette.chatre@intel.com
 L:	linux-wireless@vger.kernel.org
 L:	ipw3945-devel@lists.sourceforge.net
 W:	http://intellinuxwireless.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rchatre/iwlwifi-2.6.git
+T:	git kernel.org:/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
 S:	Supported
 
 IOC3 ETHERNET DRIVER
-- 
1.5.3.4

