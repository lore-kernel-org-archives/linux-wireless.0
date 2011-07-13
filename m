Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53999 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965100Ab1GMIl1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 04:41:27 -0400
Message-Id: <20110713084031.752929662@sipsolutions.net> (sfid-20110713_104130_706984_F7FB7AF9)
Date: Wed, 13 Jul 2011 10:39:10 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 02/11] iwlagn: remove wireless extensions inclusions
References: <20110713083908.713123063@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

linux/wireless.h and net/iw_handler.h headers are
for wireless extensions only, so mac80211 drivers
shouldn't be including them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c   |    1 -
 drivers/net/wireless/iwlwifi/iwl-2000.c   |    1 -
 drivers/net/wireless/iwlwifi/iwl-5000.c   |    1 -
 drivers/net/wireless/iwlwifi/iwl-6000.c   |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    1 -
 drivers/net/wireless/iwlwifi/iwl-led.c    |    1 -
 7 files changed, 7 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn.c	2011-07-13 10:01:13.000000000 +0200
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c	2011-07-13 10:04:15.000000000 +0200
@@ -38,7 +38,6 @@
 #include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
-#include <linux/wireless.h>
 #include <linux/firmware.h>
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c	2011-07-13 10:02:54.000000000 +0200
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c	2011-07-13 10:02:58.000000000 +0200
@@ -30,7 +30,6 @@
 #include <linux/delay.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
-#include <linux/wireless.h>
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
 #include <asm/unaligned.h>
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c	2011-07-13 10:02:54.000000000 +0200
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c	2011-07-13 10:02:59.000000000 +0200
@@ -30,7 +30,6 @@
 #include <linux/delay.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
-#include <linux/wireless.h>
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
 #include <asm/unaligned.h>
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c	2011-07-13 10:02:54.000000000 +0200
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c	2011-07-13 10:03:00.000000000 +0200
@@ -31,7 +31,6 @@
 #include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
-#include <linux/wireless.h>
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
 #include <asm/unaligned.h>
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c	2011-07-13 10:02:54.000000000 +0200
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c	2011-07-13 10:03:02.000000000 +0200
@@ -30,7 +30,6 @@
 #include <linux/delay.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
-#include <linux/wireless.h>
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
 #include <asm/unaligned.h>
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2011-07-13 10:02:54.000000000 +0200
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2011-07-13 10:03:03.000000000 +0200
@@ -27,7 +27,6 @@
 #include <linux/init.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
-#include <linux/wireless.h>
 #include <net/mac80211.h>
 
 #include <linux/netdevice.h>
--- a/drivers/net/wireless/iwlwifi/iwl-led.c	2011-07-13 10:02:54.000000000 +0200
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c	2011-07-13 10:03:05.000000000 +0200
@@ -31,7 +31,6 @@
 #include <linux/delay.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
-#include <linux/wireless.h>
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
 #include <asm/unaligned.h>


