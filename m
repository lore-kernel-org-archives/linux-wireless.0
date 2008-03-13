Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ryu.zarb.org ([212.85.153.228]:48746 "EHLO ryu.zarb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbYCMSb2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2008 14:31:28 -0400
Subject: [PATCH] iwlwifi: fix a typo in Kconfig message
From: Pascal Terjan <pterjan@mandriva.com>
To: yi.zhu@intel.com, reinette.chatre@intel.com
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Content-Type: text/plain
Date: Thu, 13 Mar 2008 19:13:24 +0100
Message-Id: <1205432004.1469.1.camel@plop> (sfid-20080313_183132_794035_2DA876E2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pascal Terjan <pterjan@mandriva.com>
---
 drivers/net/wireless/iwlwifi/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 5b7c016..94b1e34 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -25,7 +25,7 @@ config IWL4965
 	  runs.
 
 	  If you want to compile the driver as a module ( = code which can be
-	  inserted in and remvoed from the running kernel whenever you want),
+	  inserted in and removed from the running kernel whenever you want),
 	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
 	  module will be called iwl4965.ko.
 
@@ -98,7 +98,7 @@ config IWL3945
 	  runs.
 
 	  If you want to compile the driver as a module ( = code which can be
-	  inserted in and remvoed from the running kernel whenever you want),
+	  inserted in and removed from the running kernel whenever you want),
 	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
 	  module will be called iwl3945.ko.
 
-- 
1.5.4.3

