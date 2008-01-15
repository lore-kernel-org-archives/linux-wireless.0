Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:49030 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbYAOC1B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2008 21:27:01 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/12] iwlwifi: remove reference to non-existent documentation
Date: Mon, 14 Jan 2008 17:46:24 -0800
Message-Id: <1200361585-31801-12-git-send-email-reinette.chatre@intel.com> (sfid-20080115_024518_625257_ABE30C34)
In-Reply-To: <1200361585-31801-11-git-send-email-reinette.chatre@intel.com>
References: <1200361585-31801-1-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-2-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-3-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-4-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-5-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-6-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-7-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-8-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-9-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-10-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-11-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The external iwlwifi driver comes with a README file that is
referenced by the Kconfig. This README is not present in the
driver included in the kernel. Remove references to this
documentation.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 66ca942..d1af938 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -9,17 +9,15 @@ config IWL4965
 
 	  This driver uses the kernel's mac80211 subsystem.
 
-	  See <file:Documentation/networking/README.iwlwifi> for
-	  information on the capabilities currently enabled in this
-	  driver and for tips for debugging any issues or problems.
-
 	  In order to use this driver, you will need a microcode (uCode)
 	  image for it. You can obtain the microcode from:
 
 	          <http://intellinuxwireless.org/>.
 
-	  See the above referenced README.iwlwifi for information on where
-	  to install the microcode images.
+	  The microcode is typically installed in /lib/firmware. You can
+	  look in the hotplug script /etc/hotplug/firmware.agent to
+	  determine which directory FIRMWARE_DIR is set to when the script
+	  runs.
 
 	  If you want to compile the driver as a module ( = code which can be
 	  inserted in and remvoed from the running kernel whenever you want),
@@ -92,17 +90,15 @@ config IWL3945
 
 	  This driver uses the kernel's mac80211 subsystem.
 
-	  See <file:Documentation/networking/README.iwlwifi> for
-	  information on the capabilities currently enabled in this
-	  driver and for tips for debugging any issues or problems.
-
 	  In order to use this driver, you will need a microcode (uCode)
 	  image for it. You can obtain the microcode from:
 
 	          <http://intellinuxwireless.org/>.
 
-	  See the above referenced README.iwlwifi for information on where
-	  to install the microcode images.
+	  The microcode is typically installed in /lib/firmware. You can
+	  look in the hotplug script /etc/hotplug/firmware.agent to
+	  determine which directory FIRMWARE_DIR is set to when the script
+	  runs.
 
 	  If you want to compile the driver as a module ( = code which can be
 	  inserted in and remvoed from the running kernel whenever you want),
-- 
1.5.3.4

