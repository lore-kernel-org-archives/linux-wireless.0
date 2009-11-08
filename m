Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35622 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755532AbZKHW1a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 17:27:30 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/4] refresh patches
Date: Sun,  8 Nov 2009 23:27:10 +0100
Message-Id: <1257719231-2031-4-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1257719231-2031-1-git-send-email-hauke@hauke-m.de>
References: <1257719231-2031-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/patches/01-netdev.patch                  |    2 +-
 compat/patches/08-rename-iwl4965-config.patch   |    2 +-
 compat/patches/09-threaded-irq.patch            |    2 +-
 compat/patches/15-symbol-export-conflicts.patch |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/compat/patches/01-netdev.patch b/compat/patches/01-netdev.patch
index 0a858f2..2048348 100644
--- a/compat/patches/01-netdev.patch
+++ b/compat/patches/01-netdev.patch
@@ -511,7 +511,7 @@ without creating a headache on maintenance of the pathes.
  #define LBS_DEB_LEAVE	0x00000002
 --- a/drivers/net/wireless/mac80211_hwsim.c	2009-08-18 16:18:52.829350750 -0700
 +++ b/drivers/net/wireless/mac80211_hwsim.c	2009-08-18 16:18:52.977352457 -0700
-@@ -816,16 +816,22 @@
+@@ -872,16 +872,22 @@
  	.name = "mac80211_hwsim"
  };
  
diff --git a/compat/patches/08-rename-iwl4965-config.patch b/compat/patches/08-rename-iwl4965-config.patch
index 3b90c0f..78a6b6f 100644
--- a/compat/patches/08-rename-iwl4965-config.patch
+++ b/compat/patches/08-rename-iwl4965-config.patch
@@ -16,7 +16,7 @@ CONFIG_IWL4965 has to be set to y, to build correctly.
  iwlagn-$(CONFIG_IWL5000) += iwl-1000.o
 --- a/drivers/net/wireless/iwlwifi/iwl-agn.c	2009-11-02 08:07:33.000000000 -0800
 +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c	2009-11-02 08:07:33.000000000 -0800
-@@ -3323,10 +3323,10 @@
+@@ -3416,10 +3416,10 @@
  
  /* Hardware specific file defines the PCI IDs table for that hardware module */
  static struct pci_device_id iwl_hw_card_ids[] = {
diff --git a/compat/patches/09-threaded-irq.patch b/compat/patches/09-threaded-irq.patch
index e59cafc..a5aace6 100644
--- a/compat/patches/09-threaded-irq.patch
+++ b/compat/patches/09-threaded-irq.patch
@@ -51,7 +51,7 @@ thread in process context as well.
  	b43_release_firmware(dev);
 --- a/drivers/net/wireless/b43/b43.h	2009-10-19 11:36:44.000000000 +0900
 +++ b/drivers/net/wireless/b43/b43.h	2009-10-19 11:36:45.000000000 +0900
-@@ -747,6 +747,9 @@
+@@ -745,6 +745,9 @@
  	unsigned int tx_count;
  	unsigned int rx_count;
  #endif
diff --git a/compat/patches/15-symbol-export-conflicts.patch b/compat/patches/15-symbol-export-conflicts.patch
index 70ff4c9..1f2e9e6 100644
--- a/compat/patches/15-symbol-export-conflicts.patch
+++ b/compat/patches/15-symbol-export-conflicts.patch
@@ -3,7 +3,7 @@ To avoid conflicts with the other export we rename our.
 
 --- a/net/mac80211/rx.c	2009-11-02 08:08:54.000000000 -0800
 +++ b/net/mac80211/rx.c	2009-11-02 08:08:55.000000000 -0800
-@@ -2536,7 +2536,12 @@
+@@ -2480,7 +2480,12 @@
   drop:
  	kfree_skb(skb);
  }
-- 
1.6.3.3

