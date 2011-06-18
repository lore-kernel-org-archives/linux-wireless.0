Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:65503 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab1FRQF0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 12:05:26 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/25] iwlagn: remove uneeded include to pci.h and dma_mapping.h from a few files
Date: Sat, 18 Jun 2011 08:34:12 -0700
Message-Id: <1308411271-26093-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110618_180531_755413_C2FE9140)
In-Reply-To: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    2 --
 drivers/net/wireless/iwlwifi/iwl-2000.c |    2 --
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 --
 drivers/net/wireless/iwlwifi/iwl-6000.c |    2 --
 drivers/net/wireless/iwlwifi/iwl-led.c  |    2 --
 5 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 454b541..2daca80 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -27,8 +27,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/pci.h>
-#include <linux/dma-mapping.h>
 #include <linux/delay.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index a6a259b..406eb2f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -27,8 +27,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/pci.h>
-#include <linux/dma-mapping.h>
 #include <linux/delay.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index c71fa44..06fe9ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -27,8 +27,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/pci.h>
-#include <linux/dma-mapping.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/skbuff.h>
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index b3785ec..c66bbc6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -27,8 +27,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/pci.h>
-#include <linux/dma-mapping.h>
 #include <linux/delay.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 1a8ce4a..7ef2b23 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -28,8 +28,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/pci.h>
-#include <linux/dma-mapping.h>
 #include <linux/delay.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
-- 
1.7.0.4

