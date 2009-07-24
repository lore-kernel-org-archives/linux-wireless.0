Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23614 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814AbZGXSNS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 14:13:18 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, Pavel Machek <pavel@ucw.cz>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/14] iwlwifi: fix LED config option
Date: Fri, 24 Jul 2009 11:13:10 -0700
Message-Id: <1248459194-10239-12-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
References: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pavel Machek <pavel@ucw.cz>

IWLWIFI_LEDS option should certainly have help comment, and should
default to y.

Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index e092af0..99310c0 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -9,6 +9,9 @@ config IWLWIFI
 config IWLWIFI_LEDS
 	bool "Enable LED support in iwlagn and iwl3945 drivers"
 	depends on IWLWIFI
+	default y
+	---help---
+	  Select this if you want LED support.
 
 config IWLWIFI_SPECTRUM_MEASUREMENT
 	bool "Enable Spectrum Measurement in iwlagn driver"
-- 
1.5.6.3

