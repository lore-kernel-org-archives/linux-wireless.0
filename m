Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44238 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757849AbZKXDaO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 22:30:14 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 1/8] MAINTAINERS: Add iwmc3200wifi entry
Date: Tue, 24 Nov 2009 11:33:26 +0800
Message-Id: <1259033613-25600-2-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1259033613-25600-1-git-send-email-yi.zhu@intel.com>
References: <1259033613-25600-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

Update MAINTAINERS with the Intel supported iwmc3200wifi entry.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 MAINTAINERS |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d97513f..749981d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2788,6 +2788,15 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
 S:	Supported
 F:	drivers/net/wireless/iwlwifi/
 
+INTEL WIRELESS MULTICOMM 3200 WIFI (iwmc3200wifi)
+M:	Samuel Ortiz <samuel.ortiz@intel.com>
+M:	Zhu Yi <yi.zhu@intel.com>
+M:	Intel Linux Wireless <ilw@linux.intel.com>
+L:	linux-wireless@vger.kernel.org
+S:	Supported
+W:	http://wireless.kernel.org/en/users/Drivers/iwmc3200wifi
+F:	drivers/net/wireless/iwmc3200wifi/
+
 IOC3 ETHERNET DRIVER
 M:	Ralf Baechle <ralf@linux-mips.org>
 L:	linux-mips@linux-mips.org
-- 
1.6.0.4

