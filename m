Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:51858 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab0LPA6A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 19:58:00 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/4] mwifiex: keep exactly one space after #include
Date: Wed, 15 Dec 2010 16:57:58 -0800
Message-Id: <1292461079-26318-3-git-send-email-bzhao@marvell.com>
In-Reply-To: <1292461079-26318-1-git-send-email-bzhao@marvell.com>
References: <1292461079-26318-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kiran Divekar <dkiran@marvell.com>

Signed-off-by: Kiran Divekar <dkiran@marvell.com>
---
 drivers/net/wireless/mwifiex/decl.h |    6 +++---
 drivers/net/wireless/mwifiex/main.c |    6 +++---
 drivers/net/wireless/mwifiex/main.h |   34 +++++++++++++++++-----------------
 drivers/net/wireless/mwifiex/sdio.h |   10 +++++-----
 4 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index ea27216..155c071 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -20,9 +20,9 @@
 #ifndef _MWIFIEX_DECL_H_
 #define _MWIFIEX_DECL_H_
 
-#include        <linux/wait.h>
-#include        <linux/timer.h>
-#include	<linux/wireless.h>
+#include <linux/wait.h>
+#include <linux/timer.h>
+#include <linux/wireless.h>
 
 
 #define MWIFIEX_MAX_BSS_NUM         (1)
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 09319db..4e1ac6f 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -17,9 +17,9 @@
  * this warranty disclaimer.
  **/
 
-#include	"main.h"
-#include	"wmm.h"
-#include	"cfg80211.h"
+#include "main.h"
+#include "wmm.h"
+#include "cfg80211.h"
 
 #define VERSION	"1.0"
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index be7156c..8bb8b45 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -20,24 +20,24 @@
 #ifndef _MWIFIEX_MAIN_H_
 #define _MWIFIEX_MAIN_H_
 
-#include        <linux/kernel.h>
-#include        <linux/module.h>
-#include        <linux/sched.h>
-#include        <linux/semaphore.h>
-#include        <linux/ip.h>
-#include        <linux/skbuff.h>
-#include        <linux/if_arp.h>
-#include        <linux/etherdevice.h>
-#include        <net/sock.h>
-#include        <net/lib80211.h>
-#include	<linux/firmware.h>
-#include        <linux/ctype.h>
-
-#include	"decl.h"
-#include	"ioctl.h"
-#include	"ieee.h"
-#include	"util.h"
-#include	"fw.h"
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/semaphore.h>
+#include <linux/ip.h>
+#include <linux/skbuff.h>
+#include <linux/if_arp.h>
+#include <linux/etherdevice.h>
+#include <net/sock.h>
+#include <net/lib80211.h>
+#include <linux/firmware.h>
+#include <linux/ctype.h>
+
+#include "decl.h"
+#include "ioctl.h"
+#include "ieee.h"
+#include "util.h"
+#include "fw.h"
 
 extern const char driver_version[];
 extern struct mwifiex_adapter *g_adapter;
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index 116a1eb..5a70cd8 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -21,12 +21,12 @@
 #define	_MWIFIEX_SDIO_H
 
 
-#include        <linux/mmc/sdio.h>
-#include        <linux/mmc/sdio_ids.h>
-#include        <linux/mmc/sdio_func.h>
-#include        <linux/mmc/card.h>
+#include <linux/mmc/sdio.h>
+#include <linux/mmc/sdio_ids.h>
+#include <linux/mmc/sdio_func.h>
+#include <linux/mmc/card.h>
 
-#include	"main.h"
+#include "main.h"
 
 #define BLOCK_MODE	1
 #define BYTE_MODE	0
-- 
1.7.0.2

