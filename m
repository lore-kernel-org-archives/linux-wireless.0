Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.190]:59891 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbYHWF41 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2008 01:56:27 -0400
Received: by ti-out-0910.google.com with SMTP id b6so452807tic.23
        for <linux-wireless@vger.kernel.org>; Fri, 22 Aug 2008 22:56:26 -0700 (PDT)
Date: Sat, 23 Aug 2008 13:56:25 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: linville@tuxdriver.com
Subject: wireless: remove unused #include <version.h>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20080823132819.1286.WEIYI.HUANG@gmail.com> (sfid-20080823_075639_708977_E8754A46)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver(s) below do not use LINUX_VERSION_CODE nor KERNEL_VERSION.
  drivers/net/wireless/b43legacy/main.c
  drivers/net/wireless/iwlwifi/iwl-3945-led.c
  drivers/net/wireless/iwlwifi/iwl-led.c
  drivers/net/wireless/iwlwifi/iwl-rfkill.c

This patch removes the said #include <version.h>.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 2541c81..1cb77db 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -34,7 +34,6 @@
 #include <linux/moduleparam.h>
 #include <linux/if_arp.h>
 #include <linux/etherdevice.h>
-#include <linux/version.h>
 #include <linux/firmware.h>
 #include <linux/wireless.h>
 #include <linux/workqueue.h>
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index d333696..705c65b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -27,7 +27,6 @@

 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index cb11c4a..4eee1b1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -27,7 +27,6 @@

 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
index e5e5846..5d64229 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
@@ -27,7 +27,6 @@
  *****************************************************************************/
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/init.h>

 #include <net/mac80211.h>

